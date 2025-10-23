module TopModule(
    input clk,
    input d,
    output q
);

reg [1:0] ff;

always @(posedge clk) ff[0] <= d;
always @(negedge clk) ff[1] <= d;

assign q = (clk == 1'b1) ? ff[0] : ff[1];

endmodule