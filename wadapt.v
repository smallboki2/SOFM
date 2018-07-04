module wadapt(
	i_data,
	i_xi,
	i_alpha,
	i_update,
	o_mi,
	i_pos
);
//in out

input[7:0] i_data;
input[7:0] i_xi;
input[15:0] i_alpha;

input i_update;

output[7:0] o_mi;

input[15:0] i_pos;
//reg
//lvalue
reg[7:0] sub,x,y;
reg[23:0] mul;
reg[23:0] mi;
reg[7:0] mio;

reg anker;
//comb
assign o_mi = (i_update && ~anker ) ? mio : i_data;

always@(*) begin
	x = i_pos[7:0];
	y = i_pos[15:8];
	//add or remove ankers
	anker = (x == 0 && y == 0)||(x == 0 && y == 66)||(x == 66 && y == 0)||(x == 99 && y == 33)||(x == 33 && y == 99)||(x == 99 && y == 99);
	sub = i_xi > i_data ? i_xi - i_data : i_data - i_xi;
	mul = i_alpha * sub;
	mi = i_xi > i_data ? {i_data,16'd0} + mul : {i_data,16'd0} - mul;
	mio = mi[15:0] > 16'h8000 ? mi[23:16] + 1 : mi[23:16];
end
//seq

endmodule
