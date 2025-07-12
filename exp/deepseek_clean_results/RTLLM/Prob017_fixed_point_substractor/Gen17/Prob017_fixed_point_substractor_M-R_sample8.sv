module fixed_point_subtractor #(
    parameter N = 32,        // Total number of bits
    parameter Q = 16         // Number of fractional bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Static parameter validation
    initial begin
        if (Q >= N) $error("Q must be less than N");
    end

    // Direct subtraction with implicit zero handling
    assign c = a - b;

endmodule