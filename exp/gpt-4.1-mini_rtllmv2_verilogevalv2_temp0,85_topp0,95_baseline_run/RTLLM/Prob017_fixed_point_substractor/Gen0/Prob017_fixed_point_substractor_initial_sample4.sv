module fixed_point_subtractor #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register for the result magnitude and sign
    reg [N-2:0] mag_a, mag_b; // magnitude excluding sign bit
    reg sign_a, sign_b;
    reg [N-1:0] res;
    reg [N-1:0] abs_a, abs_b;
    reg [N-1:0] mag_res;
    reg sign_res;
    reg cmp_a_gt_b;

    // Extract sign and magnitude from inputs (two's complement interpretation)
    // sign bit: MSB
    always @(*) begin
        sign_a = a[N-1];
        sign_b = b[N-1];

        // Compute absolute values of a and b
        if (sign_a) // negative
            abs_a = (~a) + 1'b1;
        else
            abs_a = a;

        if (sign_b) // negative
            abs_b = (~b) + 1'b1;
        else
            abs_b = b;

        // Compare magnitudes
        cmp_a_gt_b = (abs_a > abs_b);

        if (sign_a == sign_b) begin
            // Same sign subtraction: magnitude subtraction
            if (cmp_a_gt_b) begin
                mag_res = abs_a - abs_b;
                sign_res = sign_a;
            end else if (abs_a == abs_b) begin
                mag_res = 0;
                sign_res = 1'b0; // zero sign bit set to 0
            end else begin
                mag_res = abs_b - abs_a;
                sign_res = sign_a; // same sign as inputs
            end
        end else begin
            // Different sign => addition of magnitudes
            mag_res = abs_a + abs_b;
            // Sign of result depends on which magnitude is greater
            if (cmp_a_gt_b)
                sign_res = sign_a;
            else if (abs_a == abs_b)
                sign_res = 1'b0; // zero
            else
                sign_res = sign_b;
        end

        // Construct two's complement result from sign and magnitude
        if (mag_res == 0)
            res = {1'b0, {(N-1){1'b0}}}; // zero with sign 0
        else if (sign_res == 1'b0)
            res = mag_res; // positive number in two's complement
        else
            res = (~mag_res) + 1'b1; // negative number in two's complement

        c = res;
    end

endmodule