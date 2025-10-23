module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);
    wire [2:0] sum;
    assign sum = a + b + c + d;  // Sum all inputs as integers
    assign q = ~sum[0];          // Output 1 when sum is even (LSB=0)
endmodule