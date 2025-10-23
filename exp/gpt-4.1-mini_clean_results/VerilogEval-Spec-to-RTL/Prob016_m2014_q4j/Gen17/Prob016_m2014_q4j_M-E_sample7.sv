module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    // Directly perform addition; sum is 5 bits to hold overflow
    assign sum = x + y;
endmodule