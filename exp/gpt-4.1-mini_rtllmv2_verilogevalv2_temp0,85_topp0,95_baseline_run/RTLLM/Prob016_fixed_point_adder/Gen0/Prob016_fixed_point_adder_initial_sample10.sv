module fixed_point_adder #(
    parameter Q = 8,      // Number of fractional bits
    parameter N = 16      // Total number of bits (including sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal registers for calculation
    reg [N-2:0] abs_a;
    reg [N-2:0] abs_b;
    reg [N-1:0] res;

    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Compute absolute values (magnitude without sign bit)
    // For two's complement, abs = (sign)? (~val + 1) : val
    // We only consider bits [N-2:0] because MSB is sign bit
    reg [N-1:0] a_ext;
    reg [N-1:0] b_ext;
    reg [N-1:0] abs_a_full;
    reg [N-1:0] abs_b_full;

    always @(*) begin
        // Extend a and b to signed values for absolute calculation
        a_ext = a;
        b_ext = b;
        // Compute absolute value of a
        if (sign_a) 
            abs_a_full = (~a_ext) + 1;
        else 
            abs_a_full = a_ext;
        // Compute absolute value of b
        if (sign_b)
            abs_b_full = (~b_ext) + 1;
        else
            abs_b_full = b_ext;

        // Extract magnitude without sign bit
        abs_a = abs_a_full[N-2:0];
        abs_b = abs_b_full[N-2:0];

        if (sign_a == sign_b) begin
            // Same sign: add magnitudes, keep sign
            // Add absolute values plus sign bit 0 extended to N bits
            // sum magnitude
            reg [N:0] sum_mag;
            sum_mag = {1'b0, abs_a} + {1'b0, abs_b};
            // Assign sign bit same as inputs
            // Handle carry out overflow by truncation (normal fixed width)
            res[N-1]   = sign_a;
            res[N-2:0] = sum_mag[N-2:0];
        end else begin
            // Different sign: subtract smaller abs from larger abs
            if (abs_a > abs_b) begin
                // a has larger magnitude
                reg [N-1:0] diff_mag;
                diff_mag = {1'b0, abs_a} - {1'b0, abs_b};
                res[N-1]   = sign_a;      // sign from a (larger)
                res[N-2:0] = diff_mag[N-2:0];
            end else if (abs_b > abs_a) begin
                // b has larger magnitude
                reg [N-1:0] diff_mag;
                diff_mag = {1'b0, abs_b} - {1'b0, abs_a};
                res[N-1] = sign_b;        // sign from b (larger)
                res[N-2:0] = diff_mag[N-2:0];
            end else begin
                // abs_a == abs_b: result zero
                res = {N{1'b0}};
            end
        end
    end

    // Assign output
    always @(*) begin
        c = res;
    end

endmodule