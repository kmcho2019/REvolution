module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Validate parameters
    initial begin
        if (Q >= N) $error("Q must be less than N");
    end

    // Internal signals
    wire signed [N-1:0] sum;
    wire signed [N-1:0] diff;
    wire overflow;

    // Main arithmetic operations
    assign sum = a + b;
    assign diff = a - b;

    // Overflow detection (when signs match but result sign differs)
    assign overflow = (a[N-1] == b[N-1]) && (sum[N-1] != a[N-1]);

    // Result selection with saturation
    assign c = overflow ? 
               {a[N-1], {(N-1){~a[N-1]}}} :  // Saturate to max/min
               sum;                         // Normal result

endmodule