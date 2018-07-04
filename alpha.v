module alpha(
	i_number,
	i_dimdis,
	i_alpha0,
	i_alpha1,
	o_alpha,
	i_length
);

input[15:0] i_number;
input[7:0] i_dimdis;
input[15:0] i_alpha0;
input[15:0] i_alpha1;
input[15:0] i_length;

output[15:0] o_alpha;
reg[23:0] alpha;

//lvalue
assign o_alpha = alpha[15:0];


always@(*) begin
	alpha = (i_length - i_number) * i_alpha0 - i_dimdis * i_alpha1;
end

endmodule
