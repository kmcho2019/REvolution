module fixed_point_subtractor #(
    parameter integer Q = 8,       // Number of fractional bits
    parameter integer N = 16       // Total number of bits (including sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal registers
    reg [N-2:0] mag_a;   // Magnitude of a (exclude sign bit)
    reg [N-2:0] mag_b;   // Magnitude of b (exclude sign bit)
    reg sign_a;
    reg sign_b;

    reg [N-2:0] mag_res; // Magnitude result (N-1 bits)
    reg sign_res;

    reg [N-1:0] res;

    // Intermediate signals for arithmetic
    reg [N-1:0] sum_mag;
    reg [N-1:0] diff_mag;

    always @(*) begin
        // Extract sign and magnitude of inputs
        sign_a = a[N-1];
        sign_b = b[N-1];
        mag_a  = a[N-2:0];
        mag_b  = b[N-2:0];

        if (sign_a == sign_b) begin
            // Same sign subtraction: result = mag_a - mag_b, sign same as inputs
            if (mag_a >= mag_b) begin
                mag_res  = mag_a - mag_b;
                sign_res = sign_a;
            end else begin
                mag_res  = mag_b - mag_a;
                sign_res = sign_a; // Same sign, but magnitude reversed, sign same
                // Actually, per spec, sign of result is same as inputs
                // but subtraction a - b with both same sign means sign same as inputs
                // so even if mag_b > mag_a, the sign stays the same as inputs
                // but the magnitude is difference
                // Wait, this is a corner: when subtracting mag_a - mag_b and mag_b > mag_a, 
                // mathematically result is negative, sign should be reversed.
                // The problem statement says sign of result same as inputs.
                // So we keep sign same but mag_res is mag_b - mag_a
                // This is ambiguous, but we follow spec literally.
            end
        end else begin
            // Different signs: add magnitudes, sign depends on which magnitude is greater
            sum_mag = mag_a + mag_b;
            if (mag_a > mag_b) begin
                sign_res = sign_a;
                mag_res  = sum_mag[N-2:0]; // sum_mag is N-1 bits wide, mag_res N-1 bits
            end else if (mag_b > mag_a) begin
                sign_res = sign_b;
                mag_res  = sum_mag[N-2:0];
            end else begin
                // magnitudes equal, result zero
                sign_res = 1'b0;
                mag_res  = { (N-1){1'b0} };
            end
        end

        // Compose result
        res = {sign_res, mag_res};

        // If result zero, force sign bit to 0
        if (res[N-2:0] == { (N-1){1'b0} }) begin
            res[N-1] = 1'b0;
        end

        c = res;
    end

endmodule