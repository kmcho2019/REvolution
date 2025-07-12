module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg [1:0] stage;
    
    // Stage 0 registers
    reg [23:0] a_mantissa_0, b_mantissa_0;
    reg [8:0] a_exponent_0, b_exponent_0;
    reg a_sign_0, b_sign_0;
    reg special_case_0;
    reg inf_case_0, zero_case_0, nan_case_0;
    
    // Stage 1 registers
    reg [47:0] product_1;
    reg [8:0] exp_sum_1;
    reg sign_1;
    reg special_case_1;
    reg inf_case_1, zero_case_1, nan_case_1;
    
    // Stage 2 wires
    wire product_msb = product_1[47];
    wire [23:0] norm_mantissa = product_msb ? product_1[47:24] : product_1[46:23];
    wire [8:0] norm_exponent = product_msb ? (exp_sum_1 + 1) : exp_sum_1;
    
    // Rounding logic
    wire guard_bit = product_1[22];
    wire round_bit = product_1[21];
    wire sticky = |product_1[20:0];
    wire round_inc = guard_bit && (round_bit || sticky);
    wire [23:0] rounded_mantissa = round_inc ? norm_mantissa + 1 : norm_mantissa;
    
    // Overflow/underflow detection
    wire overflow = (norm_exponent >= 255) || (&norm_exponent[7:0] && round_inc);
    wire underflow = (norm_exponent == 0) || (norm_exponent[8]);
    
    // Output selection
    wire [31:0] normal_out = {sign_1, overflow ? 8'hFF : underflow ? 8'h00 : norm_exponent[7:0], 
                             overflow ? 23'b0 : underflow ? 23'b0 : rounded_mantissa[22:0]};
    
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
            // Clear pipeline registers
            {a_mantissa_0, b_mantissa_0, a_exponent_0, b_exponent_0} <= 0;
            {a_sign_0, b_sign_0, special_case_0, inf_case_0, zero_case_0, nan_case_0} <= 0;
            {product_1, exp_sum_1, sign_1, special_case_1, inf_case_1, zero_case_1, nan_case_1} <= 0;
        end else begin
            case (stage)
                0: begin // Input and special case detection
                    // Extract components
                    a_sign_0 <= a[31];
                    b_sign_0 <= b[31];
                    a_exponent_0 <= a[30:23];
                    b_exponent_0 <= b[30:23];
                    a_mantissa_0 <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa_0 <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    // Detect special cases
                    nan_case_0 <= a_nan || b_nan || ((a_inf || b_inf) && (a_zero || b_zero));
                    inf_case_0 <= (a_inf || b_inf) && ~nan_case_0;
                    zero_case_0 <= (a_zero || b_zero) && ~nan_case_0;
                    special_case_0 <= nan_case_0 || inf_case_0 || zero_case_0;
                    
                    stage <= 1;
                end
                
                1: begin // Multiplication and exponent processing
                    // Wallace tree multiplication (simplified for readability)
                    product_1 <= a_mantissa_0 * b_mantissa_0;
                    
                    // Exponent processing
                    exp_sum_1 <= a_exponent_0 + b_exponent_0 - 9'd127;
                    sign_1 <= a_sign_0 ^ b_sign_0;
                    
                    // Pipeline special cases
                    special_case_1 <= special_case_0;
                    inf_case_1 <= inf_case_0;
                    zero_case_1 <= zero_case_0;
                    nan_case_1 <= nan_case_0;
                    
                    stage <= 2;
                end
                
                2: begin // Normalization, rounding and output
                    if (nan_case_1) begin
                        z <= {1'b0, 8'hFF, 1'b1, 22'b0}; // Canonical NaN
                    end else if (inf_case_1) begin
                        z <= {sign_1, 8'hFF, 23'b0};
                    end else if (zero_case_1) begin
                        z <= {sign_1, 31'b0};
                    end else begin
                        z <= normal_out;
                    end
                    
                    stage <= 0;
                end
            endcase
        end
    end

endmodule