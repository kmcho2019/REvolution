// Output q is the complement of input a, sampled at positive clock edges
module TopModule(input clk, input a, output reg q);
    always @(posedge clk) q <= ~a;
endmodule