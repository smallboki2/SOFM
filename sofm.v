module sofm(
	i_clk,
	i_rst_n,
	i_data,
	i_itr,
	i_dim,
	i_len,
	i_ninput,
	i_nitr,
	i_ndim,
	i_xi,
	i_xi_1,
	o_data,
	o_update,
	o_pos,
	i_alpha0,
	i_alpha1,
	i_alpha2,
	i_state
);

//inout
input i_clk;
input i_rst_n;

input[63:0] i_data;
input[15:0] i_dim;
input[7:0] i_len;
input[7:0] i_xi;
input[7:0] i_xi_1;
input[15:0] i_ninput;
input[15:0] i_nitr;
input[15:0] i_ndim;
input[15:0] i_itr;
output[63:0] o_data;
output o_update;
output[15:0] o_pos;
input[15:0] i_alpha0;
input[15:0] i_alpha1;
input[15:0] i_alpha2;
input[1:0] i_state;
//reg

reg[15:0] win_r,win_w;
reg[15:0] poswin_r,poswin_w;//for currentn input temporrary
reg[15:0] poswinp_r,poswinp_w;//for previous input
reg nxt_r,nxt_w;

reg[15:0] pos0_r,pos0_w;
reg[15:0] pos1_r,pos1_w;
reg[15:0] pos2_r,pos2_w;
reg[15:0] pos3_r,pos3_w;
reg[15:0] pos4_r,pos4_w;
reg[15:0] pos5_r,pos5_w;
reg[15:0] pos6_r,pos6_w;
reg[15:0] pos7_r,pos7_w;

//position sent into comparators
reg[15:0] pos0_p_r,pos0_p_w;
reg[15:0] pos1_p_r,pos1_p_w;
reg[15:0] pos2_p_r,pos2_p_w;
reg[15:0] pos3_p_r,pos3_p_w;
reg[15:0] pos4_p_r,pos4_p_w;
reg[15:0] pos5_p_r,pos5_p_w;
reg[15:0] pos6_p_r,pos6_p_w;
reg[15:0] pos7_p_r,pos7_p_w;

//parameters used in weight update
reg[15:0] alpha0_r,alpha0_w;
reg[15:0] alpha1_r,alpha1_w;
reg[15:0] alpha2_r,alpha2_w;
reg[15:0] alpha3_r,alpha3_w;
reg[15:0] alpha4_r,alpha4_w;
reg[15:0] alpha5_r,alpha5_w;
reg[15:0] alpha6_r,alpha6_w;
reg[15:0] alpha7_r,alpha7_w;

//lvalue

reg[63:0] mi;
reg[63:0] data_r,data_w;
reg[7:0] dimdis0,dimdis1,dimdis2,dimdis3,dimdis4,dimdis5,dimdis6,dimdis7;
reg update0_r,update0_w;
reg update1_r,update1_w;
reg update2_r,update2_w;
reg update3_r,update3_w;
reg update4_r,update4_w;
reg update5_r,update5_w;
reg update6_r,update6_w;
reg update7_r,update7_w;
reg update,nxt;
reg update0;
reg update1;
reg update2;
reg update3;
reg update4;
reg update5;
reg update6;
reg update7;
reg[7:0] absx0,absx1,absx2,absx3,absx4,absx5,absx6,absx7;
reg[7:0] absy0,absy1,absy2,absy3,absy4,absy5,absy6,absy7;
reg[7:0] disx0,disx1,disx2,disx3,disx4,disx5,disx6,disx7;
reg[7:0] disy0,disy1,disy2,disy3,disy4,disy5,disy6,disy7;
reg[7:0] minx0,minx1,minx2,minx3,minx4,minx5,minx6,minx7;
reg[7:0] miny0,miny1,miny2,miny3,miny4,miny5,miny6,miny7;
reg[1:0] cv00,cv01,cv02,cv03,cv10,cv11,cv20;
reg[7:0] wid_8;
reg[15:0] redinitr;

//connection
wire[7:0] mi0,mi1,mi2,mi3,mi4,mi5,mi6,mi7;
wire[25:0] dis0,dis1,dis2,dis3,dis4,dis5,dis6,dis7;
wire[15:0] pos00,pos01,pos02,pos03,pos10,pos11,pos20;
wire[25:0] win00,win01,win02,win03,win10,win11,win20;

reg[23:0] redius,redius0;
wire[15:0] alpha0,alpha1,alpha2,alpha3,alpha4,alpha5,alpha6,alpha7;
//sub module

//calculation of alpa
alpha a0(redinitr,dimdis0,i_alpha0,i_alpha1,alpha0,i_itr);
alpha a1(redinitr,dimdis1,i_alpha0,i_alpha1,alpha1,i_itr);
alpha a2(redinitr,dimdis2,i_alpha0,i_alpha1,alpha2,i_itr);
alpha a3(redinitr,dimdis3,i_alpha0,i_alpha1,alpha3,i_itr);
alpha a4(redinitr,dimdis4,i_alpha0,i_alpha1,alpha4,i_itr);
alpha a5(redinitr,dimdis5,i_alpha0,i_alpha1,alpha5,i_itr);
alpha a6(redinitr,dimdis6,i_alpha0,i_alpha1,alpha6,i_itr);
alpha a7(redinitr,dimdis7,i_alpha0,i_alpha1,alpha7,i_itr);
//weight update
wadapt wadapt0(data_r[7:0],i_xi_1,alpha0_r,update0_r && ~(i_ninput == 0 && i_nitr == 0),mi0,pos0_r);
wadapt wadapt1(data_r[15:8],i_xi_1,alpha1_r,update1_r && ~(i_ninput == 0 && i_nitr == 0),mi1,pos1_r);
wadapt wadapt2(data_r[23:16],i_xi_1,alpha2_r,update2_r && ~(i_ninput == 0 && i_nitr == 0),mi2,pos2_r);
wadapt wadapt3(data_r[31:24],i_xi_1,alpha3_r,update3_r && ~(i_ninput == 0 && i_nitr == 0),mi3,pos3_r);
wadapt wadapt4(data_r[39:32],i_xi_1,alpha4_r,update4_r && ~(i_ninput == 0 && i_nitr == 0),mi4,pos4_r);
wadapt wadapt5(data_r[47:40],i_xi_1,alpha5_r,update5_r && ~(i_ninput == 0 && i_nitr == 0),mi5,pos5_r);
wadapt wadapt6(data_r[55:48],i_xi_1,alpha6_r,update6_r && ~(i_ninput == 0 && i_nitr == 0),mi6,pos6_r);
wadapt wadapt7(data_r[63:56],i_xi_1,alpha7_r,update7_r && ~(i_ninput == 0 && i_nitr == 0),mi7,pos7_r);
//distance calculation unit(accumulator)
discal Dis0(i_clk,i_rst_n,i_data[7:0],mi0,i_xi,i_ndim == 0,i_ndim == i_dim,dis0,nxt,i_state);
discal Dis1(i_clk,i_rst_n,i_data[15:8],mi1,i_xi,i_ndim == 0,i_ndim == i_dim,dis1,nxt,i_state);
discal Dis2(i_clk,i_rst_n,i_data[23:16],mi2,i_xi,i_ndim == 0,i_ndim == i_dim,dis2,nxt,i_state);
discal Dis3(i_clk,i_rst_n,i_data[31:24],mi3,i_xi,i_ndim == 0,i_ndim == i_dim,dis3,nxt,i_state);
discal Dis4(i_clk,i_rst_n,i_data[39:32],mi4,i_xi,i_ndim == 0,i_ndim == i_dim,dis4,nxt,i_state);
discal Dis5(i_clk,i_rst_n,i_data[47:40],mi5,i_xi,i_ndim == 0,i_ndim == i_dim,dis5,nxt,i_state);
discal Dis6(i_clk,i_rst_n,i_data[55:48],mi6,i_xi,i_ndim == 0,i_ndim == i_dim,dis6,nxt,i_state);
discal Dis7(i_clk,i_rst_n,i_data[63:56],mi7,i_xi,i_ndim == 0,i_ndim == i_dim,dis7,nxt,i_state);
//comparators
comparator com00(dis0,pos0_p_r,dis1,pos1_p_r,win00,pos00,cv00);
comparator com01(dis2,pos2_p_r,dis3,pos3_p_r,win01,pos01,cv01);
comparator com02(dis4,pos4_p_r,dis5,pos5_p_r,win02,pos02,cv02);
comparator com03(dis6,pos6_p_r,dis7,pos7_p_r,win03,pos03,cv03);

comparator com10(win00,pos00,win01,pos01,win10,pos10,cv10);
comparator com11(win02,pos02,win03,pos03,win11,pos11,cv11);

comparator com20(win10,pos10,win11,pos11,win20,pos20,cv20);

//comb
assign o_update = update && ~(i_ninput == 0 && i_nitr == 0);
assign o_data = {mi7,mi6,mi5,mi4,mi3,mi2,mi1,mi0};
assign o_pos = pos7_r;

always@(*) begin

	redinitr = i_ninput == 0 ? i_nitr - 1 : i_nitr;
	redius0 = ((i_len + 1) >> 1) * (24'h10000 - i_alpha2 * redinitr);
	redius = redius0;//redius0[23:16] == 0 ? 24'h10000 : redius0;

	data_w = i_state == 2 ? i_data : data_r;

	absx0 = pos0_r[7:0] > poswinp_r[7:0] ? pos0_r[7:0] - poswinp_r[7:0] : poswinp_r[7:0] - pos0_r[7:0];
	absx1 = pos1_r[7:0] > poswinp_r[7:0] ? pos1_r[7:0] - poswinp_r[7:0] : poswinp_r[7:0] - pos1_r[7:0];
	absx2 = pos2_r[7:0] > poswinp_r[7:0] ? pos2_r[7:0] - poswinp_r[7:0] : poswinp_r[7:0] - pos2_r[7:0];
	absx3 = pos3_r[7:0] > poswinp_r[7:0] ? pos3_r[7:0] - poswinp_r[7:0] : poswinp_r[7:0] - pos3_r[7:0];
	absx4 = pos4_r[7:0] > poswinp_r[7:0] ? pos4_r[7:0] - poswinp_r[7:0] : poswinp_r[7:0] - pos4_r[7:0];
	absx5 = pos5_r[7:0] > poswinp_r[7:0] ? pos5_r[7:0] - poswinp_r[7:0] : poswinp_r[7:0] - pos5_r[7:0];
	absx6 = pos6_r[7:0] > poswinp_r[7:0] ? pos6_r[7:0] - poswinp_r[7:0] : poswinp_r[7:0] - pos6_r[7:0];
	absx7 = pos7_r[7:0] > poswinp_r[7:0] ? pos7_r[7:0] - poswinp_r[7:0] : poswinp_r[7:0] - pos7_r[7:0];
	absy0 = pos0_r[15:8] > poswinp_r[15:8] ? pos0_r[15:8] - poswinp_r[15:8] : poswinp_r[15:8] - pos0_r[15:8];
	absy1 = pos1_r[15:8] > poswinp_r[15:8] ? pos1_r[15:8] - poswinp_r[15:8] : poswinp_r[15:8] - pos1_r[15:8];
	absy2 = pos2_r[15:8] > poswinp_r[15:8] ? pos2_r[15:8] - poswinp_r[15:8] : poswinp_r[15:8] - pos2_r[15:8];
	absy3 = pos3_r[15:8] > poswinp_r[15:8] ? pos3_r[15:8] - poswinp_r[15:8] : poswinp_r[15:8] - pos3_r[15:8];
	absy4 = pos4_r[15:8] > poswinp_r[15:8] ? pos4_r[15:8] - poswinp_r[15:8] : poswinp_r[15:8] - pos4_r[15:8];
	absy5 = pos5_r[15:8] > poswinp_r[15:8] ? pos5_r[15:8] - poswinp_r[15:8] : poswinp_r[15:8] - pos5_r[15:8];
	absy6 = pos6_r[15:8] > poswinp_r[15:8] ? pos6_r[15:8] - poswinp_r[15:8] : poswinp_r[15:8] - pos6_r[15:8];
	absy7 = pos7_r[15:8] > poswinp_r[15:8] ? pos7_r[15:8] - poswinp_r[15:8] : poswinp_r[15:8] - pos7_r[15:8];
	
 	dimdis0 = absx0 > absy0 ? absx0 : absy0;
 	dimdis1 = absx1 > absy1 ? absx1 : absy1;
 	dimdis2 = absx2 > absy2 ? absx2 : absy2;
 	dimdis3 = absx3 > absy3 ? absx3 : absy3;
 	dimdis4 = absx4 > absy4 ? absx4 : absy4;
 	dimdis5 = absx5 > absy5 ? absx5 : absy5;
 	dimdis6 = absx6 > absy6 ? absx6 : absy6;
	dimdis7 = absx7 > absy7 ? absx7 : absy7;

	update0 = (dimdis0 <= redius[23:16] && pos0_r[15:8] <= i_len);
	update1 = (dimdis1 <= redius[23:16] && pos1_r[15:8] <= i_len);
	update2 = (dimdis2 <= redius[23:16] && pos2_r[15:8] <= i_len);
	update3 = (dimdis3 <= redius[23:16] && pos3_r[15:8] <= i_len);
	update4 = (dimdis4 <= redius[23:16] && pos4_r[15:8] <= i_len);
	update5 = (dimdis5 <= redius[23:16] && pos5_r[15:8] <= i_len);
	update6 = (dimdis6 <= redius[23:16] && pos6_r[15:8] <= i_len);
	update7 = (dimdis7 <= redius[23:16] && pos7_r[15:8] <= i_len);

	update0_w = i_state == 2 ? update0 : 0;
	update1_w = i_state == 2 ? update1 : 0;
	update2_w = i_state == 2 ? update2 : 0;
	update3_w = i_state == 2 ? update3 : 0;
	update4_w = i_state == 2 ? update4 : 0;
	update5_w = i_state == 2 ? update5 : 0;
	update6_w = i_state == 2 ? update6 : 0;
	update7_w = i_state == 2 ? update7 : 0;

	update = update0 || update1 || update2 || update3 || update4 || update5 || update6 || update7; 

	nxt = (i_state == 2 && ~(update && ~(i_ninput == 0 && i_nitr == 0))) || i_state == 3 ? 1 : 0;
	wid_8 = i_len - 8;
	if(i_state == 1) begin
		pos0_w = 0;
		pos1_w = 1;
		pos2_w = 2;
		pos3_w = 3;
		pos4_w = 4;
		pos5_w = 5;
		pos6_w = 6;
		pos7_w = 7;
	end
	else begin
		pos0_w[7:0]	= nxt && i_ndim == i_dim ? (pos0_r[7:0] > wid_8 ? pos0_r[7:0] - wid_8 - 1 : pos0_r + 8) : pos0_r[7:0];
		pos0_w[15:8]= nxt && i_ndim == i_dim ? (pos0_r[7:0] > wid_8 ? pos0_r[15:8] + 1 : pos0_r[15:8]) : pos0_r[15:8];
		pos1_w[7:0] = nxt && i_ndim == i_dim ? (pos1_r[7:0] > wid_8 ? pos1_r[7:0] - wid_8 - 1 : pos1_r + 8) : pos1_r[7:0];
		pos1_w[15:8]= nxt && i_ndim == i_dim ? (pos1_r[7:0] > wid_8 ? pos1_r[15:8] + 1 : pos1_r[15:8]) : pos1_r[15:8];
		pos2_w[7:0] = nxt && i_ndim == i_dim ? (pos2_r[7:0] > wid_8 ? pos2_r[7:0] - wid_8 - 1 : pos2_r + 8) : pos2_r[7:0];
		pos2_w[15:8]= nxt && i_ndim == i_dim ? (pos2_r[7:0] > wid_8 ? pos2_r[15:8] + 1 : pos2_r[15:8]) : pos2_r[15:8];
		pos3_w[7:0] = nxt && i_ndim == i_dim ? (pos3_r[7:0] > wid_8 ? pos3_r[7:0] - wid_8 - 1 : pos3_r + 8) : pos3_r[7:0];
		pos3_w[15:8]= nxt && i_ndim == i_dim ? (pos3_r[7:0] > wid_8 ? pos3_r[15:8] + 1 : pos3_r[15:8]) : pos3_r[15:8];
		pos4_w[7:0] = nxt && i_ndim == i_dim ? (pos4_r[7:0] > wid_8 ? pos4_r[7:0] - wid_8 - 1 : pos4_r + 8) : pos4_r[7:0];
		pos4_w[15:8]= nxt && i_ndim == i_dim ? (pos4_r[7:0] > wid_8 ? pos4_r[15:8] + 1 : pos4_r[15:8]) : pos4_r[15:8];
		pos5_w[7:0] = nxt && i_ndim == i_dim ? (pos5_r[7:0] > wid_8 ? pos5_r[7:0] - wid_8 - 1 : pos5_r + 8) : pos5_r[7:0];
		pos5_w[15:8]= nxt && i_ndim == i_dim ? (pos5_r[7:0] > wid_8 ? pos5_r[15:8] + 1 : pos5_r[15:8]) : pos5_r[15:8];
		pos6_w[7:0] = nxt && i_ndim == i_dim ? (pos6_r[7:0] > wid_8 ? pos6_r[7:0] - wid_8 - 1 : pos6_r + 8) : pos6_r[7:0];
		pos6_w[15:8]= nxt && i_ndim == i_dim ? (pos6_r[7:0] > wid_8 ? pos6_r[15:8] + 1 : pos6_r[15:8]) : pos6_r[15:8];
		pos7_w[7:0] = nxt && i_ndim == i_dim ? (pos7_r[7:0] > wid_8 ? pos7_r[7:0] - wid_8 - 1 : pos7_r + 8) : pos7_r[7:0];
		pos7_w[15:8]= nxt && i_ndim == i_dim ? (pos7_r[7:0] > wid_8 ? pos7_r[15:8] + 1 : pos7_r[15:8]) : pos7_r[15:8];
	end

	pos0_p_w = nxt && i_ndim == i_dim ? pos0_r : pos0_p_r;
	pos1_p_w = nxt && i_ndim == i_dim ? pos1_r : pos1_p_r;
	pos2_p_w = nxt && i_ndim == i_dim ? pos2_r : pos2_p_r;
	pos3_p_w = nxt && i_ndim == i_dim ? pos3_r : pos3_p_r;
	pos4_p_w = nxt && i_ndim == i_dim ? pos4_r : pos4_p_r;
	pos5_p_w = nxt && i_ndim == i_dim ? pos5_r : pos5_p_r;
	pos6_p_w = nxt && i_ndim == i_dim ? pos6_r : pos6_p_r;
	pos7_p_w = nxt && i_ndim == i_dim ? pos7_r : pos7_p_r;

	nxt_w = nxt && i_ndim == i_dim ? 1 : 0;
	
	//the valid signal for comparators
	cv00[0] = 1;
	cv00[1] = pos1_p_r > {i_len,i_len} ? 0 : 1;
	cv01[0] = pos2_p_r > {i_len,i_len} ? 0 : 1;
	cv01[1] = pos3_p_r > {i_len,i_len} ? 0 : 1;
	cv02[0] = pos4_p_r > {i_len,i_len} ? 0 : 1;
	cv02[1] = pos5_p_r > {i_len,i_len} ? 0 : 1;
	cv03[0] = pos6_p_r > {i_len,i_len} ? 0 : 1;
	cv03[1] = pos7_p_r > {i_len,i_len} ? 0 : 1;

	cv10[0] = pos1_p_r > {i_len,i_len} ? 0 : 1;
	cv10[1] = pos3_p_r > {i_len,i_len} ? 0 : 1;
	cv11[0] = pos5_p_r > {i_len,i_len} ? 0 : 1;
	cv11[1] = pos7_p_r > {i_len,i_len} ? 0 : 1;
                                   
	cv20[0] = pos3_p_r > {i_len,i_len} ? 0 : 1;
	cv20[1] = pos7_p_r > {i_len,i_len} ? 0 : 1;

	if(nxt_r) begin
		if(pos0_p_r == 0) begin
			poswin_w = pos20;
			win_w = win20;
		end
		else begin
			poswin_w = win_r > win20 ? pos20 : poswin_r;
			win_w = win_r > win20 ? win20 : win_r;
		end
	end
	else begin
		poswin_w = poswin_r;
		win_w = win_r;
	end

	poswinp_w = i_state == 1 ? ( win_r > win20 ? pos20 : poswin_r ) : poswinp_r;

	alpha0_w = update ? alpha0 : alpha0_r ;
	alpha1_w = update ? alpha1 : alpha1_r ;
	alpha2_w = update ? alpha2 : alpha2_r ;
	alpha3_w = update ? alpha3 : alpha3_r ;
	alpha4_w = update ? alpha4 : alpha4_r ;
	alpha5_w = update ? alpha5 : alpha5_r ;
	alpha6_w = update ? alpha6 : alpha6_r ;
	alpha7_w = update ? alpha7 : alpha7_r ;

end
//seq
always@(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) begin
		alpha0_r <= 0;
		alpha1_r <= 0;
		alpha2_r <= 0;
		alpha3_r <= 0;
		alpha4_r <= 0;
		alpha5_r <= 0;
		alpha6_r <= 0;
		alpha7_r <= 0;
		pos0_r <= 0;
		pos1_r <= 1;
		pos2_r <= 2;
		pos3_r <= 3;
		pos4_r <= 4;
		pos5_r <= 5;
		pos6_r <= 6;
		pos7_r <= 7;
		pos0_p_r <= 0;
		pos1_p_r <= 1;
		pos2_p_r <= 2;
		pos3_p_r <= 3;
		pos4_p_r <= 4;
		pos5_p_r <= 5;
		pos6_p_r <= 6;
		pos7_p_r <= 7;
		win_r <= 0;
		poswin_r <= 0;
		poswinp_r <= 0;
		update0_r <= 0;
		update1_r <= 0;
		update2_r <= 0;
		update3_r <= 0;
		update4_r <= 0;
		update5_r <= 0;
		update6_r <= 0;
		update7_r <= 0;
		nxt_r <= 0;
		data_r <= 0;
	end
	else begin
		alpha0_r <= alpha0_w;
		alpha1_r <= alpha1_w;
		alpha2_r <= alpha2_w;
		alpha3_r <= alpha3_w;
		alpha4_r <= alpha4_w;
		alpha5_r <= alpha5_w;
		alpha6_r <= alpha6_w;
		alpha7_r <= alpha7_w;
		pos0_r <= pos0_w;
		pos1_r <= pos1_w;
		pos2_r <= pos2_w;
		pos3_r <= pos3_w;
		pos4_r <= pos4_w;
		pos5_r <= pos5_w;
		pos6_r <= pos6_w;
		pos7_r <= pos7_w;
		pos0_p_r <= pos0_p_w;
		pos1_p_r <= pos1_p_w;
		pos2_p_r <= pos2_p_w;
		pos3_p_r <= pos3_p_w;
		pos4_p_r <= pos4_p_w;
		pos5_p_r <= pos5_p_w;
		pos6_p_r <= pos6_p_w;
		pos7_p_r <= pos7_p_w;
		win_r <= win_w;
		poswin_r <= poswin_w;
		poswinp_r <= poswinp_w;
		update0_r <= update0_w;
		update1_r <= update1_w;
		update2_r <= update2_w;
		update3_r <= update3_w;
		update4_r <= update4_w;
		update5_r <= update5_w;
		update6_r <= update6_w;
		update7_r <= update7_w;
		nxt_r <= nxt_w;
		data_r <= data_w;
	end
end

endmodule
