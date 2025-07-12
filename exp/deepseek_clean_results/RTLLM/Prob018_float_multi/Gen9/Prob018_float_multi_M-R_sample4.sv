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
    reg special_case_p1;

    // Pipeline stage 2 registers
    reg [47:0] product_p2;
    reg [7:0] z_exponent_p2;
    reg z_sign_p2;
    reg special_case_p2;

    // Pipeline stage 3 registers
    reg [22:0] z_mantissa_p3;
    reg [7:0] z_exponent_p3;
    reg z_sign_p3;
    reg special_case_p3;

    // Combinational special case detection
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    wire special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;

    // Mantissa multiplication (combinational)
    wire [47:0] product = a_mantissa_p1 * b_mantissa_p1;

    // Normalization and rounding (combinational)
    wire [47:0] normalized_product = product[47] ? product : {product[46:0], 1'b0};
    wire [23:0] rounded_mantissa = normalized_product[47:24] + 
                                 ((normalized_product[23] & (normalized_product[22] | |normalized_product[21:0])) ? 1 : 0);
    wire [7:0] final_exponent = z_exponent_p2 + (product[47] ? 1 : 0);

    // Pipeline stage 1: Input processing
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_mantissa_p1 <= 0;
            b_mantissa_p1 <= 0;
            a_exponent_p1 <= 0;
            b_exponent_p1 <= 0;
            a_sign_p1 <= 0;
            b_sign_p1 <= 0;
            special_case_p1 <= 0;
        end else begin
            a_sign_p1 <= a[31];
            b_sign_p1 <= b[31];
            a_exponent_p1 <= a[30:23];
            b_exponent_p1 <= b[30:23];
            a_mantissa_p1 <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
            b_mantissa_p1 <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
            special_case_p1 <= special_case;
        end
    end

    // Pipeline stage 2: Multiplication and exponent handling
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_p2 <= 0;
            z_exponent_p2 <= 0;
            z_sign_p2 <= 0;
            special_case_p2 <= 0;
        end else begin
            product_p2 <= product;
            z_exponent_p2 <= a_exponent_p1 + b_exponent_p1 - 8'd127;
            z_sign_p2 <= a_sign_p1 ^ b_sign_p1;
            special_case_p2 <= special_case_p1;
        end
    end

    // Pipeline stage 3: Normalization and output preparation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z_mantissa_p3 <= 0;
            z_exponent_p3 <= 0;
            z_sign_p3 <= 0;
            special_case_p3 <= 0;
        end else begin
            z_mantissa_p3 <= rounded_mantissa[22:0];
            z_exponent_p3 <= final_exponent;
            z_sign_p3 <= z_sign_p2;
            special_case_p3 <= special_case_p2;
        end
    end

    // Output generation (combinational)
    always @(*) begin
        if (special_case_p3) begin
            if (a_nan | b_nan) begin
                z = 32'h7FC00000;  // NaN
            end else if (a_inf | b_inf) begin
                z = (a_zero | b_zero) ? 32'h7FC00000 : {z_sign_p3, 8'hFF, 23'b0};
            end else if (a_zero | b_zero) begin
                z = {z_sign_p3, 31'b0};
            end
        end else if (z_exponent_p3[7:0] == 8'hFF) begin
            z = {z_sign_p3, 8'hFF, 23'b0};  // Overflow
        end else if (z_exponent_p3[7:0] == 0) begin
            z = {z_sign_p3, 31'b0};  // Underflow
        end else begin
            z = {z_sign_p3, z_exponent_p3[7:0], z_mantissa_p3};
        end
    end

endmodule