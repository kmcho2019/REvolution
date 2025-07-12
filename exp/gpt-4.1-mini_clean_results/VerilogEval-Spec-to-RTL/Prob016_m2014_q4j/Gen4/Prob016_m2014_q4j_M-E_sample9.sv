module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    // Behavioral addition; the result is 5 bits to include the carry out
    assign sum = x + y;
endmodule