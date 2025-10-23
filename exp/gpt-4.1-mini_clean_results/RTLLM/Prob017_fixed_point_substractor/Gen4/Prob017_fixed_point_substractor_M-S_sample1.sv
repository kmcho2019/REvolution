module fixed_point_subtractor #(
    parameter integer N = 16, // Total bits (including sign)
    parameter integer Q = 8   // Fractional bits (not directly used in calculation)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Interpret inputs as signed values
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Perform subtraction
    wire signed [N-1:0] res = a_signed - b_signed;

    // Zero detection
    wire zero_result = (res == 0);

    // If zero, force sign bit to 0; else keep res as is
    assign c = zero_result ? {1'b0, {(N-1){1'b0}}} : res;

endmodule