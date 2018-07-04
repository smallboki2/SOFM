module inoutcontrol(
	i_clk,
	i_rst_n,
	o_init,
	i_d,
	o_d,
	o_addr,
	o_read,
	o_write,
	o_dim,
	o_len,
	i_pos,
	o_ninput,
	o_nitr,
	o_ndim,
	o_itr,
	o_state,
	i_update,
	i_updatedata,
	o_xi,
	o_xi_1,
	o_alpha0,
	o_alpha1,
	o_alpha2,
	o_done,
	o_nwin,
	o_d1,
	i_q1,
	o_addr1,
	o_read1,
	o_write1
);

//in out
input i_clk;
input i_rst_n;

output o_init;

input[63:0] i_d;
output[63:0] o_d;
output[19:0] o_addr;
output o_read;
output o_write;

output[15:0] o_d1;
input[15:0] i_q1;
output[19:0] o_addr1;
output o_read1;
output o_write1;

output[15:0] o_dim;
output[7:0] o_len;
input[15:0] i_pos;
output[15:0] o_ninput;
output[15:0] o_nitr;
output[15:0] o_ndim;
output[15:0] o_itr;
input i_update;
input[63:0] i_updatedata;

output[1:0] o_state;
output[7:0] o_xi;
output[7:0] o_xi_1;
output[15:0] o_alpha0;
output[15:0] o_alpha1;
output[15:0] o_alpha2;
output o_done;
output o_nwin;
//reg
reg[1:0] state_r,state_w;

reg[19:0] posinput_r,posinput_w;
reg[19:0] posneuron_r,posneuron_w;

reg[15:0] dimcnt_r,dimcnt_w;

reg[15:0] cntinput_r,cntinput_w;
reg[15:0] cntitr_r,cntitr_w;

reg[63:0] updatedata_r,updatedata_w;

reg[15:0] dim_r,dim_w;
reg[7:0] len_r,len_w;
reg[7:0] wid_r,wid_w;
reg[15:0] ninput_r,ninput_w;
reg[15:0] nitr_r,nitr_w;
reg[15:0] alpha0_r,alpha0_w;
reg[15:0] alpha1_r,alpha1_w;
reg[15:0] alpha2_r,alpha2_w;
//lvalue
reg[31:0] inputdim;
reg read;
reg write;
reg[19:0] addr;
reg[19:0] addr1;
reg[7:0] inputvalue;
reg[7:0] xi,xi_1;
//comb
assign o_init = state_r == 0;
assign o_d = i_updatedata;
assign o_addr = addr;
assign o_read = read && ~(cntinput_r > ninput_r);
assign o_write = write && ~(cntinput_r > ninput_r);

assign o_d1 = 0;
assign o_addr1 = addr1;
assign o_read1 = 1;
assign o_write1 = 0;

assign o_dim = dim_r;
assign o_len = len_r;
assign o_xi = i_q1[7:0];
assign o_xi_1 = i_q1[15:8];
assign o_state = state_r;
assign o_done = cntitr_r == nitr_r && ~(cntitr_r == 0);
assign o_ninput = cntinput_r;
assign o_nitr = cntitr_r;
assign o_ndim = dimcnt_r;
assign o_alpha0 = alpha0_r;
assign o_alpha1 = alpha1_r;
assign o_alpha2 = alpha2_r;
assign o_itr = nitr_r;
assign o_nwin = state_r == 2 && state_w == 1;
assign o_stall = state_r == 1;

always@(*) begin
	dim_w = state_r == 0 && dimcnt_r == 0 ? i_d[15:0] : dim_r;
	len_w = state_r == 0 && dimcnt_r == 0 ? i_d[23:16] : len_r;
	wid_w = state_r == 0 && dimcnt_r == 0 ? i_d[31:24] : wid_r;
	ninput_w = state_r == 0 && dimcnt_r == 0 ? i_d[47:32] : ninput_r;
	nitr_w = state_r == 0 && dimcnt_r == 0 ? i_d[63:48] : nitr_r;
	alpha0_w = state_r == 0 && dimcnt_r == 1 ? i_d[15:0] : alpha0_r;
	alpha1_w = state_r == 0 && dimcnt_r == 1 ? i_d[31:16] : alpha1_r;
	alpha2_w = state_r == 0 && dimcnt_r == 1 ? i_d[47:32] : alpha2_r;
	updatedata_w = state_r == 2 && i_update ? i_updatedata : updatedata_r;
end

always@(*) begin
	inputdim = (i_d[15:0] + 1) * (i_d[23:16] + 1) * (i_d[31:24] + 1);
	case(state_r)
		0 : begin//initialization
			read = 1;
			write = 0;
			posinput_w = 0;
			posneuron_w = 2;
			state_w = dimcnt_r == 2 ? 2 : 0;
			addr = dimcnt_r;
			addr1 = 0;
			dimcnt_w = dimcnt_r == 2 ? 0 : dimcnt_r + 1;
			cntinput_w = 0;
			cntitr_w = 0;
		end
		1 : begin//stall
			read = 1;
			write = 0;
			addr = posneuron_r;
			addr1 = posinput_r + dimcnt_r;
			cntinput_w = cntinput_r;
			cntitr_w = cntitr_r;
			state_w = 2;
			posinput_w = posinput_r;
			posneuron_w = posneuron_r;
			dimcnt_w = 0;
		end
		2 : begin//neurons
			read = 1;
			write = 0;
			addr = posneuron_r;
			addr1 = posinput_r + dimcnt_r;
			if(i_update) begin
				posneuron_w = posneuron_r;
				state_w = 3;
				dimcnt_w = dimcnt_r;
				cntinput_w = cntinput_r;
				cntitr_w = cntitr_r;
				posinput_w = posinput_r;
			end
			else if(((i_pos[15:8] >= len_r && i_pos[7:0] >= wid_r) || (i_pos[15:8] > len_r)) && (dimcnt_r == dim_r)) begin
				cntinput_w = cntinput_r == ninput_r ? 0 : cntinput_r + 1;
				cntitr_w = cntinput_r == ninput_r ? cntitr_r + 1 : cntitr_r;
				state_w = 1;
				posinput_w = cntinput_r == ninput_r ? 0 : posinput_r + 1 + dim_r;
				posneuron_w = 2;
				dimcnt_w = 0;
			end
			else begin
				posneuron_w = posneuron_r + 1;
				posinput_w = posinput_r;
				state_w = 2;
				dimcnt_w = dimcnt_r == dim_r ? 0 : dimcnt_r + 1;
				cntinput_w = cntinput_r;
				cntitr_w = cntitr_r;
			end
		end
		default begin//write back
			read = 0;
			write = 1;
			addr = posneuron_r;
			addr1 = posinput_r + dimcnt_r;
			posneuron_w = (((i_pos[15:8] >= len_r && i_pos[7:0] >= wid_r) || (i_pos[15:8] > len_r)) && (dimcnt_r == dim_r)) ? 2 : posneuron_r + 1;
			state_w = (((i_pos[15:8] >= len_r && i_pos[7:0] >= wid_r) || (i_pos[15:8] > len_r)) && (dimcnt_r == dim_r)) ? 1 : 2;
			if(cntinput_r == ninput_r) begin
				cntinput_w = (((i_pos[15:8] >= len_r && i_pos[7:0] >= wid_r) || (i_pos[15:8] > len_r)) && (dimcnt_r == dim_r))? 0 : cntinput_r;
				cntitr_w =  (((i_pos[15:8] >= len_r && i_pos[7:0] >= wid_r) || (i_pos[15:8] > len_r)) && (dimcnt_r == dim_r))? cntitr_r + 1 : cntitr_r;
				posinput_w = (((i_pos[15:8] >= len_r && i_pos[7:0] >= wid_r) || (i_pos[15:8] > len_r)) && (dimcnt_r == dim_r)) ? 0 : posinput_r;
			end
			else begin
				cntinput_w = (((i_pos[15:8] >= len_r && i_pos[7:0] >= wid_r) || (i_pos[15:8] > len_r)) && (dimcnt_r == dim_r)) ? cntinput_r + 1 : cntinput_r;	
				cntitr_w = cntitr_r;
				posinput_w = (((i_pos[15:8] >= len_r && i_pos[7:0] >= wid_r) || (i_pos[15:8] > len_r)) && (dimcnt_r == dim_r)) ? posinput_r + dim_r + 1 : posinput_r;
			end
			dimcnt_w = dimcnt_r == dim_r ? 0 : dimcnt_r + 1;
		end
	endcase
end
//seq
always@(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) begin
		state_r <= 0;
		posinput_r <= 0;
		posneuron_r <= 1;
		dimcnt_r <= 0;
    
		cntinput_r <= 0;
		cntitr_r <= 0;
    
		updatedata_r <= 0;
    
		dim_r <= 0;
		len_r <= 0;
		wid_r <= 0;
		ninput_r <= 0;
		nitr_r <= 0;
		alpha0_r <= 0;
		alpha1_r <= 0;
		alpha2_r <= 0;
	end
	else begin
		state_r <= state_w;
		posinput_r <= posinput_w;
		posneuron_r <= posneuron_w;
		dimcnt_r <= dimcnt_w;
    
		cntinput_r <= cntinput_w;
		cntitr_r <= cntitr_w;
    
		updatedata_r <= updatedata_w;
    
		dim_r <= dim_w;
		len_r <= len_w;
		wid_r <= wid_w;
		ninput_r <= ninput_w;
		nitr_r <= nitr_w;
		alpha0_r <= alpha0_w;
		alpha1_r <= alpha1_w;
		alpha2_r <= alpha2_w;
	end
end

endmodule
