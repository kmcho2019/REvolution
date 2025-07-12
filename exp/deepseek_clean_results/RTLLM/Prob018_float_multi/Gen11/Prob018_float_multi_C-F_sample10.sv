module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stages
    reg [1:0] stage;
    
    // Stage 1 registers
    reg [23:0] a_mantissa_s1, b_mantissa_s1;
    reg [7:0] a_exponent_s1, b_exponent_s1;
    reg a_sign_s1, b_sign_s1;
    reg special_case_s1;
    reg [31:0] special_result_s1;
    
    // Stage 2 registers
    reg [47:0] product_s2;
    reg [7:0] z_exponent_s2;
    reg z_sign_s2;
    reg special_case_s2;
    reg [31:0] special_result_s2;
    
    // Stage 3 registers
    reg [22:0] z_mantissa_s3;
    reg [7:0] z_exponent_s3;
    reg z_sign_s3;
    reg special_case_s3;
    reg [31:0] special_result_s3;

    // Special case detection (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
            special_case_s1 <= 0;
            special_case_s2 <= 0;
            special_case_s3 <= 0;
        end else begin
            // Pipeline stage 1: Input processing and special case detection
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
                special_result_s1 <= {a[31] ^ b[31], 8'hFF, 23'b0};
            end else if (a_zero || b_zero) begin
                special_result_s1 <= {a[31] ^ b[31], 31'b0};
            end
            
            // Pipeline stage 2: Multiplication and exponent calculation
            product_s2 <= a_mantissa_s1 * b_mantissa_s1;
            z_exponent_s2 <= a_exponent_s1 + b_exponent_s1 - 8'd127;
            z_sign_s2 <= a_sign_s1 ^ b_sign_s1;
            special_case_s2 <= special_case_s1;
            special_result_s2 <= special_result_s1;
            
            // Pipeline stage 3: Normalization, rounding and output
            special_case_s3 <= special_case_s2;
            special_result_s3 <= special_result_s2;
            z_sign_s3 <= z_sign_s2;
            
            if (special_case_s2) begin
                z <= special_result_s2;
            end else begin
                // Normalization
                if (product_s2[47]) begin
                    z_mantissa_s3 <= product_s2[46:24];
                    z_exponent_s3 <= z_exponent_s2 + 1;
                end else begin
                    z_mantissa_s3 <= product_s2[45:23];
                    z_exponent_s3 <= z_exponent_s2;
                end
                
                // Round to nearest even
                if (product_s2[22] && (|product_s2[21:0] || z_mantissa_s3[0])) begin
                    {z_exponent_s3, z_mantissa_s3} <= {z_exponent_s3, z_mantissa_s3} + 1;
                end
                
                // Final output
                if (z_exponent_s3[7] || (&z_exponent_s3)) begin  // Overflow/underflow
                    z <= {z_sign_s2, 8'hFF, 23'b0};
                end else begin
                    z <= {z_sign_s2, z_exponent_s3, z_mantissa_s3};
                end
            end
        end
    end

endmodule