module fixed_point_subtractor #(
    parameter integer N = 16, // total bits
    parameter integer Q = 8   // fractional bits (not used explicitly in arithmetic)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Perform signed subtraction directly
    wire signed [N-1:0] signed_a = $signed(a);
    wire signed [N-1:0] signed_b = $signed(b);
    wire signed [N-1:0] raw_res = signed_a - signed_b;

    // If result is zero, force sign bit to 0 explicitly
    wire zero = (raw_res == 0);
    wire [N-1:0] res = zero ? {1'b0, {(N-1){1'b0}}} : raw_res;

    assign c = res;

endmodule