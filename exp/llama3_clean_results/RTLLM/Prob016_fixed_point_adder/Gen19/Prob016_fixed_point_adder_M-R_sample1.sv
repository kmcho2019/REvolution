module fixed_point_adder #(
    parameter N = 16, // Total number of bits
    parameter Q = 8   // Number of fractional bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

    wire signed [N-1:0] sum;
    assign sum = (a[N-1] == b[N-1]) ? (a + b) : (a - b);

    wire overflow = (sum[N-1] != sum[N-2]);
    wire underflow = (sum == 0 && (a[N-1] != b[N-1]));

    assign c = (overflow || underflow) ? ((a[N-1] == 1'b1) ? -1 : 0) : sum;

endmodule