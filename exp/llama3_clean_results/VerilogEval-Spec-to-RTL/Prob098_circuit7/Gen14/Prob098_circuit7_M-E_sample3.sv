module TopModule(
    input clk,
    input a,
    output reg q
);

reg temp_a;

always @(posedge clk)
    temp_a <= a;

always @(posedge clk)
    q <= ~temp_a;

endmodule