module fixed_point_adder #(
    parameter integer Q = 8,   // Number of fractional bits
    parameter integer N = 16   // Total bits (including sign bit)
)(
    input  wire [N-1:0] a,    // Fixed-point input operand a
    input  wire [N-1:0] b,    // Fixed-point input operand b
    output wire [N-1:0] c     // Fixed-point addition result
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute magnitudes (absolute values) manually using two's complement
    // If negative: abs_val = ~val + 1; else abs_val = val
    reg [N-1:0] a_mag;
    reg [N-1:0] b_mag;

    // Intermediate variables for addition/subtraction results (unsigned)
    reg [N:0] sum_mag;      // one extra bit for carry out during addition
    reg [N-1:0] diff_mag;

    // Result sign and magnitude
    reg res_sign;
    reg [N-1:0] res_mag;

    // Result register (signed two's complement fixed-point)
    reg [N-1:0] res;

    always @(*) begin
        // Compute magnitude of a
        if (a_sign) 
            a_mag = (~a) + 1'b1;   // two's complement abs
        else
            a_mag = a;

        // Compute magnitude of b
        if (b_sign)
            b_mag = (~b) + 1'b1;
        else
            b_mag = b;

        if (a_sign == b_sign) begin
            // Same sign: add magnitudes
            sum_mag = {1'b0, a_mag} + {1'b0, b_mag}; // unsigned addition with carry bit

            // Set result sign same as inputs
            res_sign = a_sign;

            // If sum overflows N bits, result is truncated (wrap-around)
            res_mag = sum_mag[N-1:0];
        end else begin
            // Different signs: subtract smaller magnitude from larger magnitude
            if (a_mag == b_mag) begin
                // Result zero if magnitudes equal
                res_sign = 1'b0;
                res_mag = {N{1'b0}};
            end else if (a_mag > b_mag) begin
                diff_mag = a_mag - b_mag;
                res_sign = a_sign;   // result sign = sign of operand with larger magnitude
                res_mag = diff_mag;
            end else begin
                diff_mag = b_mag - a_mag;
                res_sign = b_sign;
                res_mag = diff_mag;
            end
        end

        // Convert magnitude and sign back to two's complement fixed-point number
        if (res_sign)
            res = ~res_mag + 1'b1;  // negative result: two's complement
        else
            res = res_mag;
    end

    assign c = res;

endmodule