module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage 1 registers
    reg [23:0] a_mantissa_p1, b_mantissa_p1;
    reg [7:0] a_exponent_p1, b_exponent_p1;
    reg a_sign_p1, b_sign_p1;
    reg a_zero_p1, b_zero_p1, a_inf_p1, b_inf_p1, a_nan_p1, b_nan_p1;

    // Pipeline stage 2 registers
    reg [47:0] product_p2;
    reg [7:0] z_exponent_p2;
    reg z_sign_p2;
    reg guard_bit_p2, sticky_p2;
    reg special_case_p2;

    // Pipeline stage 3 registers
    reg [22:0] z_mantissa_p3;
    reg [7:0] z_exponent_p3;
    reg z_sign_p3;
    reg special_case_p3;

    // Combinational logic for special cases
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);

    // Pipeline stage 1: Input processing
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_mantissa_p1 <= 0;
            b_mantissa_p1 <= 0;
            a_exponent_p1 <= 0;
            b_exponent_p1 <= 0;
            a_sign_p1 <= 0;
            b_sign_p1 <= 0;
            a_zero_p1 <= 0;
            b_zero_p1 <= 0;
            a_inf_p1 <= 0;
            b_inf_p1 <= 0;
            a_nan_p1 <= 0;
            b_nan_p1 <= 0;
        end else begin
            // Extract components
            a_sign_p1 <= a[31];
            b_sign_p1 <= b[31];
            a_exponent_p1 <= a[30:23];
            b_exponent_p1 <= b[30:23];
            a_mantissa_p1 <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
            b_mantissa_p1 <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
            
            // Special cases
            a_zero_p1 <= a_zero;
            b_zero_p1 <= b_zero;
            a_inf_p1 <= a_inf;
            b_inf_p1 <= b_inf;
            a_nan_p1 <= a_nan;
            b_nan_p1 <= b_nan;
        end
    end

    // Pipeline stage 2: Multiplication and exponent handling
    wire [8:0] exp_sum = {1'b0, a_exponent_p1} + {1'b0, b_exponent_p1};
    wire [7:0] exp_biased = exp_sum - 8'd127;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_p2 <= 0;
            z_exponent_p2 <= 0;
            z_sign_p2 <= 0;
            guard_bit_p2 <= 0;
            sticky_p2 <= 0;
            special_case_p2 <= 0;
        end else begin
            // Multiply mantissas
            product_p2 <= a_mantissa_p1 * b_mantissa_p1;
            
            // Exponent handling
            z_exponent_p2 <= exp_biased;
            z_sign_p2 <= a_sign_p1 ^ b_sign_p1;
            
            // Rounding bits
            guard_bit_p2 <= product_p2[22];
            sticky_p2 <= |product_p2[21:0];
            
            // Special case flag
            special_case_p2 <= a_nan_p1 || b_nan_p1 || a_inf_p1 || b_inf_p1 || 
                              a_zero_p1 || b_zero_p1;
        end
    end

    // Pipeline stage 3: Normalization and rounding
    wire [47:0] normalized_product = product_p2[47] ? product_p2 : {product_p2[46:0], 1'b0};
    wire [23:0] rounded_mantissa = normalized_product[47:24] + 
                                  (guard_bit_p2 && (sticky_p2 || normalized_product[24]));
    wire [7:0] final_exponent = product_p2[47] ? z_exponent_p2 + 1 : z_exponent_p2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z_mantissa_p3 <= 0;
            z_exponent_p3 <= 0;
            z_sign_p3 <= 0;
            special_case_p3 <= 0;
        end else begin
            // Normalized and rounded result
            z_mantissa_p3 <= rounded_mantissa[22:0];
            z_exponent_p3 <= rounded_mantissa[23] ? final_exponent + 1 : final_exponent;
            z_sign_p3 <= z_sign_p2;
            
            // Pass through special case flag
            special_case_p3 <= special_case_p2;
        end
    end

    // Output generation
    always @(*) begin
        if (special_case_p3) begin
            if (a_nan_p1 || b_nan_p1) begin
                z = 32'h7FC00000;  // NaN
            end else if (a_inf_p1 || b_inf_p1) begin
                z = (a_zero_p1 || b_zero_p1) ? 32'h7FC00000 : {z_sign_p3, 8'hFF, 23'b0};
            end else if (a_zero_p1 || b_zero_p1) begin
                z = {z_sign_p3, 31'b0};
            end else begin
                z = {z_sign_p3, z_exponent_p3, z_mantissa_p3};
            end
        end else if (z_exponent_p3[7:0] == 8'hFF) begin
            z = {z_sign_p3, 8'hFF, 23'b0};  // Overflow
        end else if (~|z_exponent_p3) begin
            z = {z_sign_p3, 31'b0};  // Underflow
        end else begin
            z = {z_sign_p3, z_exponent_p3, z_mantissa_p3};
        end
    end

endmodule