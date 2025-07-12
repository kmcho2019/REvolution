module fixed_point_subtractor #(
    parameter N = 32,
    parameter Q = 16
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Direct result calculation with combined operations
    assign c = (a == b) ? {1'b0, {(N-1){1'b0}}} :  // Zero case
               (a[N-1] == b[N-1]) ?                // Same sign case
                   {a[N-1], (a[N-2:0] - b[N-2:0])} :
               (a[N-1]) ?                          // a negative, b positive
                   {(a[N-2:0] > b[N-2:0]), 
                    (a[N-2:0] - b[N-2:0])} :
                   {(a[N-2:0] >= b[N-2:0]), 
                    (a[N-2:0] - b[N-2:0])};

endmodule