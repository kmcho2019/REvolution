module fixed_point_adder #(
    parameter integer N = 16,      // Total bits including sign
    parameter integer Q = 8        // Fractional bits
)(
    input  wire [N-1:0] a,         // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,         // Fixed-point input operand b (two's complement)
    output reg  [N-1:0] c          // Fixed-point output result
);

    // Internal signals with explicit widths
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Extract magnitude as unsigned (N-1 bits)
    wire [N-2:0] mag_a_unsigned = a[N-2:0];
    wire [N-2:0] mag_b_unsigned = b[N-2:0];

    // Compute absolute magnitude of a
    wire [N-2:0] abs_mag_a = sign_a ? (~mag_a_unsigned + 1'b1) : mag_a_unsigned;
    // Compute absolute magnitude of b
    wire [N-2:0] abs_mag_b = sign_b ? (~mag_b_unsigned + 1'b1) : mag_b_unsigned;

    // Intermediate results for addition and subtraction (N bits to hold carry/borrow)
    wire [N-1:0] sum_abs_mag = {1'b0, abs_mag_a} + {1'b0, abs_mag_b};
    wire [N-1:0] diff_abs_mag_ab = {1'b0, abs_mag_a} - {1'b0, abs_mag_b};
    wire [N-1:0] diff_abs_mag_ba = {1'b0, abs_mag_b} - {1'b0, abs_mag_a};

    // Result sign and magnitude registers
    reg sign_res;
    reg [N-2:0] mag_res;

    // Helper: zero check for magnitude (N-1 bits)
    wire mag_res_zero = (mag_res == {(N-1){1'b0}});

    // Combine magnitude and sign into two's complement N-bit number
    function [N-1:0] to_twos_complement;
        input [N-2:0] mag_in;
        input         sign_in;
        reg   [N-2:0] mag_tmp;
    begin
        if (sign_in) begin
            mag_tmp = ~mag_in + 1'b1;
            to_twos_complement = {1'b1, mag_tmp};
        end else begin
            to_twos_complement = {1'b0, mag_in};
        end
    end
    endfunction

    always @(*) begin
        if (sign_a == sign_b) begin
            // Same sign: add absolute magnitudes
            if (sum_abs_mag[N-1]) begin
                // Overflow beyond (N-1) bits: saturate magnitude to max value
                mag_res = {(N-1){1'b1}};  // max magnitude (all ones)
            end else begin
                mag_res = sum_abs_mag[N-2:0];
            end
            sign_res = sign_a;
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (abs_mag_a == abs_mag_b) begin
                // Result zero
                mag_res = {(N-1){1'b0}};
                sign_res = 1'b0;  // positive zero
            end else if (abs_mag_a > abs_mag_b) begin
                mag_res = diff_abs_mag_ab[N-2:0];
                sign_res = sign_a;
            end else begin
                mag_res = diff_abs_mag_ba[N-2:0];
                sign_res = sign_b;
            end
        end

        // Convert magnitude and sign back to two's complement fixed-point
        c = to_twos_complement(mag_res, sign_res);
    end

endmodule