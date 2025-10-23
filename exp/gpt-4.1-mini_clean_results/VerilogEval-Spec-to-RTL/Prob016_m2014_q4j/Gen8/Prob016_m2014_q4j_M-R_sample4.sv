module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    // Use Verilog addition operator to sum 4-bit inputs; sum[4] is overflow
    assign sum = x + y;
endmodule