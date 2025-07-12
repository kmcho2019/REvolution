module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal result with extra bit for overflow detection
    wire [N:0] result_ext = {a[N-1], a} + {b[N-1], b};

    // Overflow occurs when sign bits don't match result
    wire overflow = (result_ext[N] != result_ext[N-1]);

    // Saturated values for overflow cases
    wire [N-1:0] saturated_max = {1'b0, {(N-1){1'b1}}};
    wire [N-1:0] saturated_min = {1'b1, {(N-1){1'b0}}};

    // Select between normal result and saturated value
    assign c = overflow ? 
              (result_ext[N] ? saturated_min : saturated_max) :
              result_ext[N-1:0];

endmodule