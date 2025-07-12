module TopModule (
    input  wire [3:0] x,
    input  wire [3:0] y,
    output wire [4:0] sum
);
    // Use built-in addition operator to infer an optimized 4-bit adder with carry out
    assign sum = {1'b0, x} + {1'b0, y};
endmodule