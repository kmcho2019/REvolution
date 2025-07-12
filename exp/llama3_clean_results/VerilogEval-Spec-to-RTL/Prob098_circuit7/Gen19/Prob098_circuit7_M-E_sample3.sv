module TopModule(
    input clk,
    input a,
    output reg q
);

reg tff_out;

always @(posedge clk) 
    tff_out <= ~tff_out;

always @(posedge clk) 
    if (a) 
        q <= ~q;

endmodule