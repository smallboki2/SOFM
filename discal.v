module discal(
	i_clk,
	i_rst_n,
	i_d,
	i_mi,
	i_xi,
	i_r,
	i_com,
	o_dis,
	i_valid,
	i_state
);

input i_clk;
input i_rst_n;

input[7:0] i_d;
input[7:0] i_mi;
input[7:0] i_xi;

input i_r;
input i_com;

output[25:0] o_dis;
input i_valid;
input[1:0] i_state;
//reg
reg[25:0] sum_r,sum_w;

//lvalue
reg[7:0] sub;

assign o_dis = sum_r;

always@(*) begin
	if(i_state == 3) begin
		sub = i_mi > i_xi ? i_mi - i_xi : i_xi - i_mi;
	end
	else begin
		sub = i_d > i_xi ? i_d - i_xi : i_xi - i_d;
	end

	if(i_valid)
		sum_w = i_r ? sub : sum_r + sub;
	else
		sum_w = sum_r;

end

always@(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) begin
		sum_r <= 0;
	end
	else begin
		sum_r <= sum_w;
	end
end
endmodule
