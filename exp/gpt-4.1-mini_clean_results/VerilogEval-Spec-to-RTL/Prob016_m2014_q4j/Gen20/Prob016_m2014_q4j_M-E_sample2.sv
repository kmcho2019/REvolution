module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    assign sum = x + y; // Behavioral addition, 5-bit result includes carry out
endmodule