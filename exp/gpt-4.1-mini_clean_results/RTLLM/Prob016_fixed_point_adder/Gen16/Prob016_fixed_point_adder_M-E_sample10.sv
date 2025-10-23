module fixed_point_adder #(
    parameter integer N = 16,      // Total bits including sign
    parameter integer Q = 8        // Fractional bits
)(
    input  wire [N-1:0] a,         // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,         // Fixed-point input operand b (two's complement)
    output reg  [N-1:0] c          // Fixed-point output result
);

    // Internal registers
    reg        sign_a, sign_b;             // Sign bits of inputs
    reg [N-2:0] mag_a, mag_b;              // Magnitudes (N-1 bits: exclude sign bit)
    reg [N-1:0] abs_sum;                   // Sum of magnitudes (N bits to hold carry)
    reg [N-1:0] abs_diff;                  // Difference of magnitudes (N bits to hold borrow)
    reg [N-2:0] mag_max, mag_min;          // For comparing magnitudes
    reg        sign_res;                   // Sign bit of result
    reg [N-1:0] res;                      // Intermediate result before assignment to c

    // Function to compute absolute value of two's complement fixed-point number
    function [N-2:0] abs_mag;
        input [N-1:0] val;
        reg sign_in;
        reg [N-2:0] mag_in;
    begin
        sign_in = val[N-1];
        mag_in = val[N-2:0];
        if (sign_in)
            abs_mag = (~mag_in + 1'b1) & ((1 << (N-1)) - 1); // Two's complement magnitude
        else
            abs_mag = mag_in;
    end
    endfunction

    // Convert magnitude and sign back to two's complement fixed-point representation
    function [N-1:0] mag_sign_to_twos;
        input [N-2:0] mag_in;
        input         sign_in;
        reg   [N-2:0] mag_temp;
    begin
        if (sign_in)
            mag_sign_to_twos = {1'b1, (~mag_in + 1'b1) & ((1 << (N-1)) - 1)};
        else
            mag_sign_to_twos = {1'b0, mag_in};
    end
    endfunction

    integer i;

    always @(*) begin
        // Extract signs
        sign_a = a[N-1];
        sign_b = b[N-1];

        // Calculate magnitudes
        mag_a = abs_mag(a);
        mag_b = abs_mag(b);

        if (sign_a == sign_b) begin
            // Same sign: add absolute values
            abs_sum = mag_a + mag_b;

            // Check for carry out of magnitude bits
            if (abs_sum[N-1]) begin
                // Overflow beyond magnitude bits, saturate max magnitude
                mag_max = { (N-1){1'b1} };
            end else begin
                mag_max = abs_sum[N-2:0];
            end

            sign_res = sign_a;
            res = mag_sign_to_twos(mag_max, sign_res);
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (mag_a == mag_b) begin
                // Result zero with positive sign
                mag_max = { (N-1){1'b0} };
                sign_res = 1'b0;
                res = mag_sign_to_twos(mag_max, sign_res);
            end else if (mag_a > mag_b) begin
                abs_diff = mag_a - mag_b;
                mag_max = abs_diff[N-2:0];
                sign_res = sign_a; // sign of operand with larger magnitude
                res = mag_sign_to_twos(mag_max, sign_res);
            end else begin
                abs_diff = mag_b - mag_a;
                mag_max = abs_diff[N-2:0];
                sign_res = sign_b; // sign of operand with larger magnitude
                res = mag_sign_to_twos(mag_max, sign_res);
            end
        end

        c = res;
    end

endmodule