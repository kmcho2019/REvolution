module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire [2:0] sum; // 3 bits to hold sum from 0 to 4

    assign sum = a + b + c + d;     // sum inputs as integer bits
    assign q = ~sum[0];             // q = 1 if sum is even (sum[0] == 0)

endmodule