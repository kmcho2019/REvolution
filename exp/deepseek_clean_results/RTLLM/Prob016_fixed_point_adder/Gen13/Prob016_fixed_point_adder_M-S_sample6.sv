module fixed_point_adder #(
    parameter Q = 8,    // Number of fractional bits
    parameter N = 16     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c,
    output wire overflow
);

    // Perform signed addition directly
    wire signed [N-1:0] sum = $signed(a) + $signed(b);
    
    // Assign outputs
    assign c = sum[N-1:0];
    assign overflow = (a[N-1] == b[N-1]) && (sum[N-1] != a[N-1]);

endmodule