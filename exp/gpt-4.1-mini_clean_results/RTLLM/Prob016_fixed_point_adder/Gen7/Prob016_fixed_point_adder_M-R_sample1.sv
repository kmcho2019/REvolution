module fixed_point_adder #(
    parameter integer Q = 8,      // Number of fractional bits (precision)
    parameter integer N = 16      // Total number of bits including sign
)(
    input  wire [N-1:0] a,        // Fixed-point input operand A
    input  wire [N-1:0] b,        // Fixed-point input operand B
    output reg  [N-1:0] c         // Fixed-point addition result
);

    // Internal signals
    reg sign_a;
    reg sign_b;
    reg [N-2:0] abs_a; // Magnitude without sign bit
    reg [N-2:0] abs_b;
    reg [N-2:0] abs_res;
    reg sign_res;

    always @(*) begin
        sign_a = a[N-1];
        sign_b = b[N-1];
        // Compute absolute values
        abs_a = sign_a ? (~a[N-2:0] + 1'b1) : a[N-2:0];
        abs_b = sign_b ? (~b[N-2:0] + 1'b1) : b[N-2:0];

        if (sign_a == sign_b) begin
            // Same sign: add magnitudes
            abs_res = abs_a + abs_b;
            sign_res = sign_a;
        end else begin
            // Different sign: subtract smaller from larger magnitude
            if (abs_a >= abs_b) begin
                abs_res = abs_a - abs_b;
                sign_res = sign_a; // sign of the larger magnitude
            end else begin
                abs_res = abs_b - abs_a;
                sign_res = sign_b;
            end
        end

        // Assign result with restored sign
        if (abs_res == 0)
            c = {1'b0, {(N-1){1'b0}}}; // zero is positive
        else if (sign_res)
            c = {1'b1, (~abs_res + 1'b1)}; // negative, convert magnitude back to two's complement
        else
            c = {1'b0, abs_res}; // positive magnitude
    end

endmodule