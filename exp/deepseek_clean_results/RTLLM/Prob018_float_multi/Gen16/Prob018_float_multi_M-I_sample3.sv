module float_multi(
    input clk,
    input rst,
    input en,        // Enable signal for clock gating
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage 1 registers
    reg stage1_valid;
    reg a_sign_p1, b_sign_p1;
    reg [7:0] a_exp_p1, b_exp_p1;
    reg [23:0] a_man_p1, b_man_p1;
    reg is_nan_p1, is_inf_p1, is_zero_p1, inf_zero_p1;

    // Pipeline stage 2 registers
    reg stage2_valid;
    reg sign_p2;
    reg [7:0] exp_sum_p2;
    reg [47:0] product_p2;
    reg is_nan_p2, is_inf_p2, is_zero_p2, inf_zero_p2;

    // Combinational logic for stage 1
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [23:0] a_man = (a_exp != 0) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
    wire [23:0] b_man = (b_exp != 0) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};

    wire is_nan = (a_exp == 8'hFF && |a[22:0]) || (b_exp == 8'hFF && |b[22:0]);
    wire is_inf = (a_exp == 8'hFF && ~|a[22:0]) || (b_exp == 8'hFF && ~|b[22:0]);
    wire is_zero = (a_exp == 0 && ~|a[22:0]) || (b_exp == 0 && ~|b[22:0]);
    wire inf_zero = ((a_exp == 8'hFF && b_exp == 0) || (b_exp == 8'hFF && a_exp == 0));

    // Pipeline stage 1
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_valid <= 1'b0;
        end else if (en) begin
            stage1_valid <= 1'b1;
            a_sign_p1 <= a_sign;
            b_sign_p1 <= b_sign;
            a_exp_p1 <= a_exp;
            b_exp_p1 <= b_exp;
            a_man_p1 <= a_man;
            b_man_p1 <= b_man;
            is_nan_p1 <= is_nan;
            is_inf_p1 <= is_inf;
            is_zero_p1 <= is_zero;
            inf_zero_p1 <= inf_zero;
        end else begin
            stage1_valid <= 1'b0;
        end
    end

    // Pipeline stage 2
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage2_valid <= 1'b0;
            z <= 0;
        end else if (stage1_valid) begin
            stage2_valid <= 1'b1;
            sign_p2 <= a_sign_p1 ^ b_sign_p1;
            exp_sum_p2 <= a_exp_p1 + b_exp_p1 - 8'd127;
            product_p2 <= a_man_p1 * b_man_p1;
            is_nan_p2 <= is_nan_p1;
            is_inf_p2 <= is_inf_p1;
            is_zero_p2 <= is_zero_p1;
            inf_zero_p2 <= inf_zero_p1;
        end else begin
            stage2_valid <= 1'b0;
        end
    end

    // Output stage
    always @(*) begin
        if (stage2_valid) begin
            if (is_nan_p2 || inf_zero_p2) begin
                z = 32'h7FC00000; // NaN
            end else if (is_inf_p2) begin
                z = {sign_p2, 8'hFF, 23'b0}; // Infinity
            end else if (is_zero_p2) begin
                z = {sign_p2, 31'b0}; // Zero
            end else begin
                // Normalization and rounding
                wire norm_bit = product_p2[47];
                wire [7:0] final_exp = norm_bit ? exp_sum_p2 + 1 : exp_sum_p2;
                wire [22:0] final_man = norm_bit ? product_p2[46:24] : product_p2[45:23];
                
                if (&final_exp || (final_exp == 0)) begin // Overflow/underflow
                    z = {sign_p2, 8'hFF, 23'b0}; // Infinity
                end else begin
                    z = {sign_p2, final_exp, final_man};
                end
            end
        end else begin
            z = 0;
        end
    end

endmodule