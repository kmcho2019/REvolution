module fixed_point_subtractor #(
    parameter N = 32,        // Total bits (integer + fractional)
    parameter Q = 16         // Fractional bits (Q <= N-1)
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Main computation in single assign statement
    assign c = (a[N-2:0] == b[N-2:0]) ? {1'b0, {(N-1){1'b0}}} :  // Zero case
               (a[N-1] == b[N-1]) ? 
                   {a[N-1], (a[N-2:0] - b[N-2:0])} :             // Same signs
                   {((a[N-2:0] > b[N-2:0]) ? a[N-1] : b[N-1]),   // Different signs
                    (a[N-2:0] + b[N-2:0])};

endmodule