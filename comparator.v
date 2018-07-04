module comparator(
	i_s0,
	i_pos0,
	i_s1,
	i_pos1,
	o_win,
	o_pos,
	valid
);
//inout

input[25:0] i_s0;
input[15:0] i_pos0;
input[25:0] i_s1;
input[15:0] i_pos1;

output[25:0] o_win;
output[15:0] o_pos;
input[1:0] valid;
//reg
reg[25:0] win;
reg[15:0] pos;
//lvalue
assign o_win = win;
assign o_pos = pos;
//comb
always@(*) begin
	win = i_s0 > i_s1 && valid == 3 ? i_s1 : i_s0;
	pos = i_s0 > i_s1 && valid == 3 ? i_pos1 : i_pos0;
end
//seq

endmodule
