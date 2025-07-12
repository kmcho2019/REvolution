module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg [1:0] stage;
    reg a_sign_p1, b_sign_p1;
    reg [7:0] a_exp_p1, b_exp_p1;
    reg [23:0] a_man_p1, b_man_p1;
    reg special_case_p1;
    reg [7:0] exp_sum_p2;
    reg [47:0] product_p2;
    reg sign_p2;
    reg special_case_p2;
    reg [7:0] final_exp_p3;
    reg [22:0] final_man_p3;
    reg sign_p3;
    reg special_case_p3;

    // Combinational signals
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [23:0] a_man = (a_exp != 0) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
    wire [23:0] b_man = (b_exp != 0) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};

    // Special case detection (stage 0)
    wire is_nan = (a_exp == 8'hFF && |a[22:0]) || (b_exp == 8'hFF && |b[22:0]);
    wire is_inf = (a_exp == 8'hFF && ~|a[22:0]) || (b_exp == 8'hFF && ~|b[22:0]);
    wire is_zero = (a_exp == 0 && ~|a[22:0]) || (b_exp == 0 && ~|b[22:0]);
    wire inf_zero = ((a_exp == 8'hFF && b_exp == 0) || (b_exp == 8'hFF && a_exp == 0));
    wire special_case = is_nan | is_inf | is_zero | inf_zero;

    // Pipeline stage 1: Input registration and special case detection
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            special_case_p1 <= 0;
        end else begin
            stage <= stage + 1;
            a_sign_p1 <= a_sign;
            b_sign_p1 <= b_sign;
            a_exp_p1 <= a_exp;
            b_exp_p1 <= b_exp;
            a_man_p1 <= a_man;
            b_man_p1 <= b_man;
            special_case_p1 <= special_case;
        end
    end

    // Pipeline stage 2: Multiplication and exponent calculation
    always @(posedge clk) begin
        if (stage == 1) begin
            product_p2 <= a_man_p1 * b_man_p1;
            exp_sum_p2 <= a_exp_p1 + b_exp_p1 - 8'd127;
            sign_p2 <= a_sign_p1 ^ b_sign_p1;
            special_case_p2 <= special_case_p1;
        end
    end

    // Pipeline stage 3: Normalization and rounding
    always @(posedge clk) begin
        if (stage == 2) begin
            if (special_case_p2) begin
                final_exp_p3 <= 0;
                final_man_p3 <= 0;
            end else begin
                if (product_p2[47]) begin
                    final_exp_p3 <= exp_sum_p2 + 1;
                    final_man_p3 <= product_p2[46:24];
                end else begin
                    final_exp_p3 <= exp_sum_p2;
                    final_man_p3 <= product_p2[45:23];
                end
            end
            sign_p3 <= sign_p2;
            special_case_p3 <= special_case_p2;
        end
    end

    // Output stage
    always @(posedge clk) begin
        if (rst) begin
            z <= 0;
        end else if (stage == 3) begin
            if (special_case_p3) begin
                if (is_nan || inf_zero) begin
                    z <= 32'h7FC00000; // NaN
                end else if (is_inf) begin
                    z <= {sign_p3, 8'hFF, 23'b0}; // Infinity
                end else begin
                    z <= {sign_p3, 31'b0}; // Zero
                end
            end else if (&final_exp_p3 || (final_exp_p3 == 0)) begin
                z <= {sign_p3, 8'hFF, 23'b0}; // Overflow/Underflow
            end else begin
                z <= {sign_p3, final_exp_p3, final_man_p3};
            end
        end
    end

    // Clock gating for power optimization
    wire clk_enable = (stage < 3) | (rst);
    wire gated_clk = clk & clk_enable;

endmodule