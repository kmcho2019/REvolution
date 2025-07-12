module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage 0: Input decomposition
    reg [31:0] a_reg0, b_reg0;
    reg a_sign0, b_sign0;
    reg [7:0] a_exp0, b_exp0;
    reg [23:0] a_man0, b_man0;
    reg special_case0;

    // Pipeline stage 1: Multiplication
    reg a_sign1, b_sign1;
    reg [7:0] exp_sum1;
    reg [47:0] product1;
    reg special_case1;

    // Pipeline stage 2: Normalization
    reg z_sign2;
    reg [7:0] final_exp2;
    reg [22:0] final_man2;
    reg special_case2;

    // Combinational special case detection
    wire is_nan = (a[30:23] == 8'hFF && |a[22:0]) || (b[30:23] == 8'hFF && |b[22:0]);
    wire is_inf = (a[30:23] == 8'hFF && ~|a[22:0]) || (b[30:23] == 8'hFF && ~|b[22:0]);
    wire is_zero = (a[30:23] == 0 && ~|a[22:0]) || (b[30:23] == 0 && ~|b[22:0]);
    wire inf_zero = ((a[30:23] == 8'hFF && b[30:23] == 0) || (b[30:23] == 8'hFF && a[30:23] == 0));

    // Pipeline stage 0
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg0 <= 0;
            b_reg0 <= 0;
            a_sign0 <= 0;
            b_sign0 <= 0;
            a_exp0 <= 0;
            b_exp0 <= 0;
            a_man0 <= 0;
            b_man0 <= 0;
            special_case0 <= 0;
        end else begin
            a_reg0 <= a;
            b_reg0 <= b;
            a_sign0 <= a[31];
            b_sign0 <= b[31];
            a_exp0 <= a[30:23];
            b_exp0 <= b[30:23];
            a_man0 <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
            b_man0 <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
            special_case0 <= is_nan | is_inf | is_zero | inf_zero;
        end
    end

    // Pipeline stage 1: Multiplication and exponent calculation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_sign1 <= 0;
            b_sign1 <= 0;
            exp_sum1 <= 0;
            product1 <= 0;
            special_case1 <= 0;
        end else begin
            a_sign1 <= a_sign0;
            b_sign1 <= b_sign0;
            exp_sum1 <= a_exp0 + b_exp0 - 8'd127;
            product1 <= special_case0 ? 0 : a_man0 * b_man0; // Early termination
            special_case1 <= special_case0;
        end
    end

    // Pipeline stage 2: Normalization and rounding
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z_sign2 <= 0;
            final_exp2 <= 0;
            final_man2 <= 0;
            special_case2 <= 0;
        end else begin
            z_sign2 <= a_sign1 ^ b_sign1;
            special_case2 <= special_case1;
            
            if (special_case1) begin
                final_exp2 <= 0;
                final_man2 <= 0;
            end else begin
                if (product1[47]) begin
                    final_exp2 <= exp_sum1 + 1;
                    final_man2 <= product1[46:24] + (product1[23] & (product1[22] | |product1[21:0]));
                end else begin
                    final_exp2 <= exp_sum1;
                    final_man2 <= product1[45:23] + (product1[22] & (product1[21] | |product1[20:0]));
                end
            end
        end
    end

    // Pipeline stage 3: Output generation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            if (special_case2) begin
                if (is_nan || inf_zero) begin
                    z <= 32'h7FC00000; // NaN
                end else if (is_inf) begin
                    z <= {z_sign2, 8'hFF, 23'b0}; // Infinity
                end else begin // is_zero
                    z <= {z_sign2, 31'b0}; // Zero
                end
            end else if (&final_exp2 || (final_exp2 == 0)) begin // Overflow/underflow
                z <= {z_sign2, 8'hFF, 23'b0}; // Infinity
            end else begin
                z <= {z_sign2, final_exp2, final_man2};
            end
        end
    end

endmodule