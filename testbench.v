`timescale 1ns/100ps
`define CYCLE 1
module testbench;

//reg
reg clk,clk2;
reg rst;
reg[63:0] data_mem[0:88593];
reg[15:0] input_mem[0:783999];

reg[63:0] n_writeback_r,n_writeback_w;

initial $readmemh("map1.txt",data_mem);
initial $readmemh("input1.txt",input_mem);

integer i,fp;
//lvalue
reg[63:0] rawdata;
reg[63:0] trueoutdata;
reg[63:0] data2file;

//connection
wire init;
wire[63:0] sofmdata;
wire[15:0] dim;
wire[7:0] len,wid;
wire[15:0] ninput;
wire[1:0] state;
wire[7:0] xi,xi_1;
wire[15:0] alpha0,alpha1,alpha2;

wire[63:0] data_out;
reg[63:0] data_in;
wire[15:0] data_out1;
wire[19:0] addr,addr1;
reg[15:0] data_in1;
wire read,write,read1,write1;
wire[15:0] pos;
wire update;
wire[63:0] updatedata;
wire done;
wire[15:0] nitr,itr,ndim;
wire[7:0] wx,xy;
wire nw;
wire stall;
//submodule
//
inoutcontrol INOUTCTRL(clk,rst,init,data_in,data_out,addr,read,write,dim,len,pos,ninput,nitr,ndim,itr,state,update,updatedata,xi,xi_1,alpha0,alpha1,alpha2,done,nw,data_out1,data_in1,addr1,read1,write1);

sofm SOFM(clk,rst,data_in,itr,dim,len,ninput,nitr,ndim,xi,xi_1,updatedata,update,pos,alpha0,alpha1,alpha2,state);


initial begin
	//$dumpfile("SOFM.vcd");
	//$dumpvars;
	$fsdbDumpfile("SOFM.fsdb");
	$fsdbDumpvars;
end

initial begin
	#0;
	clk = 1;
	clk2 = 1;
	rst = 0;
end

always begin
	#(`CYCLE * 0.5) clk = ~clk;
end

always begin
	#(`CYCLE * 1.5) clk2 = ~clk2;
end

initial begin
	#(`CYCLE * 0.5) rst = 1;
end

always@(*) begin
	if(read) begin
		data_in = data_mem[addr];
		n_writeback_w = n_writeback_r;
	end
	else if(write) begin
		data_mem[addr] = data_out;
		data_in = 64'dx;
		n_writeback_w = n_writeback_r + 1;
	end
	else begin
		data_in = 64'dx;
	end

	if(read1) begin
		data_in1 = input_mem[addr1];
	end
	else if(write1) begin
		input_mem[addr1] = data_out1;
	end
	else begin
		data_in1 = 16'dx;
	end
end

always@(*) begin
	if(done) begin
		$writememh("newmap2",data_mem);
		$display(n_writeback_r);
		$finish;
	end
end
/*
always@(*) begin
	if(nw) begin
		$write("%d %d\n",wx+1,xy+1);
	end
end
*/
initial begin
	fp = $fopen("newmap2","w");
	#(`CYCLE * 10000000);
	$display("Error");
	$writememh("newmap2",data_mem);
	$finish;
end

always@(posedge clk or negedge rst) begin
	n_writeback_r <= ~rst ? 0 : n_writeback_w;
end


endmodule
