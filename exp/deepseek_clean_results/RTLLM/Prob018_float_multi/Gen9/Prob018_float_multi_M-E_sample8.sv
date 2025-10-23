module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg [1:0] stage;
    reg [23:0] a_mantissa_s1, b_mantissa_s1, a_mantissa_s2, b_mantissa_s2;
    reg [7:0] a_exponent_s1, b_exponent_s1, a_exponent_s2, b_exponent_s2;
    reg a_sign_s1, b_sign_s1, a_sign_s2, b_sign_s2, a_sign_s3, b_sign_s3;
    reg [47:0] partial_prod_s2;
    reg [7:0] z_exponent_s2, z_exponent_s3;
    reg [23:0] z_mantissa_s3;
    reg special_case_s1, special_case_s2, special_case_s3;
    reg [31:0] special_result_s1, special_result_s2, special_result_s3;

    // Special case detection (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);

    // Partial product generators (12x12 multipliers)
    wire [23:0] pp0 = a_mantissa_s1[11:0] * b_mantissa_s1[11:0];
    wire [23:0] pp1 = a_mantissa_s1[23:12] * b_mantissa_s1[11:0];
    wire [23:0] pp2 = a_mantissa_s1[11:0] * b_mantissa_s1[23:12];
    wire [23:0] pp3 = a_mantissa_s1[23:12] * b_mantissa_s1[23:12];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
            special_case_s1 <= 0;
            special_case_s2 <= 0;
            special_case_s3 <= 0;
        end else begin
            // Pipeline stage 1: Input processing
            a_sign_s1 <= a[31];
            b_sign_s1 <= b[31];
            a_exponent_s1 <= a[30:23];
            b_exponent_s1 <= b[30:23];
            a_mantissa_s1 <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
            b_mantissa_s1 <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
            
            // Early special case detection
            special_case_s1 <= a_nan || b_nan || a_inf || b_inf || a_zero || b_zero;
            if (a_nan || b_nan) begin
                special_result_s1 <= 32'h7FC00000;
            end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                special_result_s1 <= 32'h7FC00000;
            end else if (a_inf || b_inf) begin
                special_result_s1 <= {a_sign_s1 ^ b_sign_s1, 8'hFF, 23'b0};
            end else if (a_zero || b_zero) begin
                special_result_s1 <= {a_sign_s1 ^ b_sign_s1, 31'b0};
            end
            
            // Pipeline stage 2: Partial multiplication and exponent calculation
            a_sign_s2 <= a_sign_s1;
            b_sign_s2 <= b_sign_s1;
            a_mantissa_s2 <= a_mantissa_s1;
            b_mantissa_s2 <= b_mantissa_s1;
            a_exponent_s2 <= a_exponent_s1;
            b_exponent_s2 <= b_exponent_s1;
            special_case_s2 <= special_case_s1;
            special_result_s2 <= special_result_s1;
            
            // Combine partial products (Wallace tree style)
            partial_prod_s2 <= {24'b0, pp0} + 
                              {12'b0, pp1, 12'b0} + 
                              {12'b0, pp2, 12'b0} + 
                              {pp3, 24'b0};
            
            // Calculate exponent (with bias adjustment)
            z_exponent_s2 <= a_exponent_s1 + b_exponent_s1 - 8'd127;
            
            // Pipeline stage 3: Normalization and rounding
            a_sign_s3 <= a_sign_s2;
            b_sign_s3 <= b_sign_s2;
            special_case_s3 <= special_case_s2;
            special_result_s3 <= special_result_s2;
            
            // Normalization
            if (partial_prod_s2[47]) begin
                z_mantissa_s3 <= partial_prod_s2[47:24];
                z_exponent_s3 <= z_exponent_s2 + 1;
            end else begin
                z_mantissa_s3 <= partial_prod_s2[46:23];
                z_exponent_s3 <= z_exponent_s2;
            end
            
            // Predictive rounding
            if (partial_prod_s2[22] && (|partial_prod_s2[21:0] || z_mantissa_s3[0])) begin
                z_mantissa_s3 <= z_mantissa_s3 + 1;
            end
            
            // Output generation
            if (special_case_s3) begin
                z <= special_result_s3;
            end else if (z_exponent_s3[7] || (&z_exponent_s3)) begin  // Overflow/underflow
                z <= {a_sign_s3 ^ b_sign_s3, 8'hFF, 23'b0};
            end else begin
                z <= {a_sign_s3 ^ b_sign_s3, z_exponent_s3, z_mantissa_s3[22:0]};
            end
        end
    end

endmodule