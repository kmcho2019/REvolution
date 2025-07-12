module fixed_point_adder #(
    parameter integer Q = 8,     // Number of fractional bits (precision)
    parameter integer N = 16     // Total number of bits including sign bit
)(
    input  wire [N-1:0] a,       // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,       // Fixed-point input operand B (two's complement)
    output reg  [N-1:0] c        // Fixed-point addition result (two's complement)
);

    // Internal registers for magnitude and sign extraction
    reg [N-2:0] mag_a;
    reg [N-2:0] mag_b;
    reg sign_a;
    reg sign_b;

    // Intermediate result signals
    reg [N-2:0] mag_res;
    reg sign_res;

    // Maximum magnitude (for N-1 bits magnitude)
    localparam [N-2:0] MAX_MAG = { (N-1){1'b1} };

    // Convert two's complement to sign-magnitude
    function [N-2:0] twos_comp_to_mag;
        input [N-1:0] val;
        reg sign;
        reg [N-2:0] magnitude;
        begin
            sign = val[N-1];
            if (sign) begin
                // Negative: magnitude = two's complement of val (without sign bit)
                magnitude = (~val[N-2:0]) + 1'b1;
            end else begin
                // Positive: magnitude = val without sign bit
                magnitude = val[N-2:0];
            end
            twos_comp_to_mag = magnitude;
        end
    endfunction

    // Convert sign-magnitude back to two's complement
    function [N-1:0] mag_to_twos_comp;
        input sign_in;
        input [N-2:0] magnitude_in;
        reg [N-1:0] twos_comp_val;
        begin
            if (sign_in) begin
                // Negative number: two's complement of magnitude
                twos_comp_val = {1'b1, (~magnitude_in) + 1'b1};
            end else begin
                // Positive number: sign bit 0 + magnitude
                twos_comp_val = {1'b0, magnitude_in};
            end
            mag_to_twos_comp = twos_comp_val;
        end
    endfunction

    // Compare magnitudes: returns 1 if mag_a > mag_b, 0 otherwise
    function mag_a_greater;
        input [N-2:0] mag_a_in;
        input [N-2:0] mag_b_in;
        begin
            mag_a_greater = (mag_a_in > mag_b_in);
        end
    endfunction

    // Saturate magnitude if overflow beyond max magnitude
    function [N-2:0] saturate_mag;
        input [N-1:0] val; // magnitude result with possible overflow bit
        begin
            // If val[N-1] (overflow bit) is set or val > MAX_MAG, saturate to MAX_MAG
            if (val[N-1] || (val[N-2:0] > MAX_MAG)) begin
                saturate_mag = MAX_MAG;
            end else begin
                saturate_mag = val[N-2:0];
            end
        end
    endfunction

    reg [N-1:0] add_result; // wider by one bit for possible overflow

    always @(*) begin
        // Extract sign bits
        sign_a = a[N-1];
        sign_b = b[N-1];

        // Convert inputs to magnitudes
        mag_a = twos_comp_to_mag(a);
        mag_b = twos_comp_to_mag(b);

        if (sign_a == sign_b) begin
            // Same sign: add magnitudes, sign is sign_a
            add_result = {1'b0, mag_a} + {1'b0, mag_b}; // one extra bit for overflow

            mag_res = saturate_mag(add_result);
            sign_res = sign_a;

        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (mag_a > mag_b) begin
                mag_res = mag_a - mag_b;
                sign_res = sign_a;
            end else if (mag_b > mag_a) begin
                mag_res = mag_b - mag_a;
                sign_res = sign_b;
            end else begin
                // Equal magnitudes => result zero
                mag_res = 0;
                sign_res = 1'b0; // positive zero
            end
        end

        // Convert back to two's complement
        res = mag_to_twos_comp(sign_res, mag_res);
    end

    // Internal register for storing result as required
    reg [N-1:0] res;
    always @(*) c = res;

endmodule