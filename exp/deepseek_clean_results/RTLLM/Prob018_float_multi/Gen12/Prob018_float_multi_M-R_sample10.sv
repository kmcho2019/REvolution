module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage 1 registers (Input Processing)
    reg [23:0] a_mantissa_1, b_mantissa_1;
    reg [9:0] a_exponent_1, b_exponent_1;
    reg a_sign_1, b_sign_1;
    reg a_zero_1, b_zero_1, a_inf_1, b_inf_1, a_nan_1, b_nan_1;
    
    // Pipeline stage 2 registers (Multiplication)
    reg [47:0] product_2;
    reg [9:0] z_exponent_2;
    reg z_sign_2;
    reg zero_2, inf_2, nan_2;
    
    // Pipeline stage 3 registers (Normalization/Rounding)
    reg [22:0] z_mantissa_3;
    reg [7:0] z_exponent_3;
    reg z_sign_3;
    reg zero_3, inf_3, nan_3;
    
    // Combinational signals
    wire guard_bit, round_bit, sticky;
    wire [23:0] rounded_mantissa;
    wire mantissa_overflow;
    
    // Stage 1: Input Processing and Special Case Detection
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_mantissa_1 <= 0;
            b_mantissa_1 <= 0;
            a_exponent_1 <= 0;
            b_exponent_1 <= 0;
            a_sign_1 <= 0;
            b_sign_1 <= 0;
            a_zero_1 <= 0;
            b_zero_1 <= 0;
            a_inf_1 <= 0;
            b_inf_1 <= 0;
            a_nan_1 <= 0;
            b_nan_1 <= 0;
        end else begin
            // Extract sign bits
            a_sign_1 <= a[31];
            b_sign_1 <= b[31];
            
            // Extract exponents
            a_exponent_1 <= {2'b0, a[30:23]};
            b_exponent_1 <= {2'b0, b[30:23]};
            
            // Extract mantissas (with implicit 1)
            a_mantissa_1 <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
            b_mantissa_1 <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
            
            // Check for special cases
            a_zero_1 <= (a[30:0] == 0);
            b_zero_1 <= (b[30:0] == 0);
            a_inf_1 <= (&a[30:23]) && (a[22:0] == 0);
            b_inf_1 <= (&b[30:23]) && (b[22:0] == 0);
            a_nan_1 <= (&a[30:23]) && (|a[22:0]);
            b_nan_1 <= (&b[30:23]) && (|b[22:0]);
        end
    end
    
    // Stage 2: Multiplication and Exponent Addition
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_2 <= 0;
            z_exponent_2 <= 0;
            z_sign_2 <= 0;
            zero_2 <= 0;
            inf_2 <= 0;
            nan_2 <= 0;
        end else begin
            // Multiply mantissas (24x24 bits)
            product_2 <= a_mantissa_1 * b_mantissa_1;
            
            // Add exponents and subtract bias (127)
            z_exponent_2 <= a_exponent_1 + b_exponent_1 - 10'd127;
            
            // XOR sign bits
            z_sign_2 <= a_sign_1 ^ b_sign_1;
            
            // Propagate special cases
            zero_2 <= a_zero_1 || b_zero_1;
            inf_2 <= a_inf_1 || b_inf_1;
            nan_2 <= a_nan_1 || b_nan_1 || (a_inf_1 && b_zero_1) || (a_zero_1 && b_inf_1);
        end
    end
    
    // Rounding logic (combinational)
    assign guard_bit = product_2[22];
    assign round_bit = product_2[21];
    assign sticky = |product_2[20:0];
    
    // Normalization and rounding (combinational)
    assign mantissa_overflow = &rounded_mantissa[23:1];
    assign rounded_mantissa = (product_2[47]) ? 
                            {product_2[47:24]} + {23'b0, guard_bit && (round_bit || sticky || product_2[24])} :
                            {product_2[46:23]} + {23'b0, guard_bit && (round_bit || sticky || product_2[23])};
    
    // Stage 3: Final Normalization and Output
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
            z_mantissa_3 <= 0;
            z_exponent_3 <= 0;
            z_sign_3 <= 0;
            zero_3 <= 0;
            inf_3 <= 0;
            nan_3 <= 0;
        end else begin
            z_mantissa_3 <= rounded_mantissa[22:0];
            z_exponent_3 <= (product_2[47]) ? 
                           (z_exponent_2 + 10'd1 + {9'b0, mantissa_overflow})[7:0] :
                           (z_exponent_2 + {9'b0, mantissa_overflow})[7:0];
            z_sign_3 <= z_sign_2;
            zero_3 <= zero_2;
            inf_3 <= inf_2;
            nan_3 <= nan_2;
            
            // Final output
            if (nan_2) begin
                z <= 32'h7FC00000;  // Canonical NaN
            end else if (inf_2) begin
                z <= {z_sign_2, 8'hFF, 23'b0};  // +/- inf
            end else if (zero_2) begin
                z <= {z_sign_2, 31'b0};  // +/- 0
            end else if (z_exponent_2[9] || (&z_exponent_2[7:0])) begin  // Overflow
                z <= {z_sign_2, 8'hFF, 23'b0};  // +/- inf
            end else if (z_exponent_2[8] || (z_exponent_2 == 0)) begin  // Underflow
                z <= {z_sign_2, 31'b0};  // +/- 0
            end else begin
                z <= {z_sign_3, z_exponent_3, z_mantissa_3};
            end
        end
    end

endmodule