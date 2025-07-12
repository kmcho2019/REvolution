module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire signed [N-1:0] a,  // First operand
    input wire signed [N-1:0] b,  // Second operand
    output wire signed [N-1:0] c  // Result (a - b)
);

    // Direct subtraction handles all sign cases and zero correctly
    // Signed arithmetic automatically handles:
    // - Same sign subtraction
    // - Different sign cases
    // - Zero result
    assign c = a - b;

    // Note: For synthesis tools that require it, you might need to add:
    // synthesis translate_off
    initial begin
        $display("Fixed Point Subtractor instantiated with N=%0d, Q=%0d", N, Q);
    end
    // synthesis translate_on

endmodule