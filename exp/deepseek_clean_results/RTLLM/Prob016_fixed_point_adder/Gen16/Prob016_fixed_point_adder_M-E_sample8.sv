module fixed_point_adder #(
    parameter Q = 8,        // Fractional bits
    parameter N = 16        // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c,
    output wire overflow
);

    // Internal extended precision signals
    wire [N:0] a_ext = {a[N-1], a};  // Sign-extended
    wire [N:0] b_ext = {b[N-1], b};  // Sign-extended
    wire [N:0] sum_ext = a_ext + b_ext;

    // Overflow detection
    assign overflow = (a[N-1] == b[N-1]) && (sum_ext[N] != a[N-1]);

    // Final result with saturation logic
    assign c = overflow ? 
               {a[N-1], {N-1{~a[N-1]}}} :  // Saturate to max/min
               sum_ext[N-1:0];              // Normal case

endmodule