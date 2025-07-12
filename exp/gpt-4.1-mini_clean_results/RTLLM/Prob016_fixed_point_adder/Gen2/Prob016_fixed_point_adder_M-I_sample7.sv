module fixed_point_adder #(
    parameter integer Q = 8,     // Number of fractional bits
    parameter integer N = 16     // Total number of bits (including sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Cast inputs to signed for ease of arithmetic and comparisons
    wire signed [N-1:0] a_s = a;
    wire signed [N-1:0] b_s = b;

    // Determine if signs are equal
    wire same_sign = (a_s[N-1] == b_s[N-1]);

    // Absolute values calculated by conditional negation without a function
    wire [N-1:0] a_abs = a_s[N-1] ? (~a_s + 1'b1) : a_s;
    wire [N-1:0] b_abs = b_s[N-1] ? (~b_s + 1'b1) : b_s;

    // Compare absolute values
    wire a_abs_ge_b_abs = (a_abs >= b_abs);

    // Declare intermediate results
    reg signed [N:0] add_result;  // one extra bit for overflow detection
    reg [N-1:0] sub_result_mag;
    reg        res_sign;

    // Saturation constant for max magnitude (all ones except sign bit)
    localparam [N-1:0] MAX_MAG = {1'b0, {(N-1){1'b1}}};

    // Combinational block selecting operation based on sign equality
    always @(*) begin
        if (same_sign) begin
            // Add absolute values with extended bit to detect overflow
            add_result = {1'b0, a_abs} + {1'b0, b_abs};

            // Saturate if overflow occurred (carry out from MSB)
            if (add_result[N]) begin
                sub_result_mag = MAX_MAG;
            end else begin
                sub_result_mag = add_result[N-1:0];
            end
            // Result sign equals input signs
            res_sign = a_s[N-1];
        end else begin
            // Subtract smaller abs from larger abs
            if (a_abs_ge_b_abs) begin
                sub_result_mag = a_abs - b_abs;
                res_sign = a_s[N-1]; // sign of operand with larger abs
            end else begin
                sub_result_mag = b_abs - a_abs;
                res_sign = b_s[N-1];
            end
        end

        // If result magnitude is zero, force sign to zero (positive)
        if (sub_result_mag == 0)
            res_sign = 1'b0;
    end

    // Form two's complement output based on sign and magnitude
    wire [N-1:0] res_twos_comp = res_sign ? (~sub_result_mag + 1'b1) : sub_result_mag;

    assign c = res_twos_comp;

endmodule