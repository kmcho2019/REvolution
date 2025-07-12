module fixed_point_subtractor #(
    parameter N = 32,        // Total number of bits
    parameter Q = 16         // Number of fractional bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Parameter validation (compile-time check)
    localparam Q_VALID = (Q < N);
    generate
        if (!Q_VALID) begin
            // This will cause elaboration error if Q >= N
            invalid_parameter invalid();
        end
    endgenerate

    // Internal signals
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    wire signed [N-1:0] diff = a_signed - b_signed;

    // Final result with explicit zero handling
    assign c = (diff == 0) ? 0 : diff;

endmodule