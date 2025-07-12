module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // One-hot state encoding
    localparam IDLE     = 6'b000001;
    localparam EXTRACT  = 6'b000010;
    localparam MUL_STG1 = 6'b000100;
    localparam MUL_STG2 = 6'b001000;
    localparam NORM     = 6'b010000;
    localparam OUTPUT   = 6'b100000;

    reg [5:0] state;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [8:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;
    reg guard_bit, round_bit, sticky;
    
    // Pipeline registers for multiplier
    reg [23:0] mul_a, mul_b;
    reg [11:0] pp0, pp1, pp2, pp3;
    
    // Special case detection (combined logic)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf_or_nan = &a[30:23];
    wire b_inf_or_nan = &b[30:23];
    wire a_nan = a_inf_or_nan && (|a[22:0]);
    wire b_nan = b_inf_or_nan && (|b[22:0]);
    wire a_inf = a_inf_or_nan && ~(|a[22:0]);
    wire b_inf = b_inf_or_nan && ~(|b[22:0]);
    
    // Exponent processing
    wire [8:0] exp_sum = a_exponent + b_exponent;
    wire [8:0] exp_biased = exp_sum - 9'd127;
    wire sign_result = a_sign ^ b_sign;
    
    // Pre-compute rounding condition
    wire round_needed = guard_bit && (round_bit || sticky || z_mantissa[0]);
    
    // Normalization
    wire [23:0] norm_mantissa = product[47] ? product[47:24] : product[46:23];
    wire [8:0] norm_exponent = product[47] ? (exp_biased + 1) : exp_biased;
    
    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {sign_result, 8'hFF, 23'b0};
    wire [31:0] zero_out = {sign_result, 31'b0};
    wire [31:0] normal_out = {sign_result, z_exponent[7:0], z_mantissa[22:0]};
    
    // Exponent overflow/underflow detection
    wire exp_overflow = (&z_exponent[7:0]) || z_exponent[8];
    wire exp_underflow = (z_exponent == 0) || z_exponent[8];
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 0;
        end else begin
            case (state)
                IDLE: begin
                    state <= EXTRACT;
                end
                
                EXTRACT: begin
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= {1'b0, a[30:23]};
                    b_exponent <= {1'b0, b[30:23]};
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    // Stage 1 of multiplier
                    mul_a <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    mul_b <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    state <= MUL_STG1;
                end
                
                MUL_STG1: begin
                    // Booth-encoded partial products (simplified)
                    pp0 <= mul_a[11:0] * mul_b[11:0];
                    pp1 <= mul_a[23:12] * mul_b[11:0];
                    pp2 <= mul_a[11:0] * mul_b[23:12];
                    pp3 <= mul_a[23:12] * mul_b[23:12];
                    
                    state <= MUL_STG2;
                end
                
                MUL_STG2: begin
                    // Final addition of partial products
                    product <= {pp3, 12'b0} + {pp2, 12'b0} + {pp1, 12'b0} + pp0;
                    z_exponent <= exp_biased;
                    z_sign <= sign_result;
                    
                    state <= NORM;
                end
                
                NORM: begin
                    // Normalize result
                    z_mantissa <= norm_mantissa;
                    z_exponent <= norm_exponent;
                    
                    // Extract rounding bits
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    sticky <= |product[20:0];
                    
                    state <= OUTPUT;
                end
                
                OUTPUT: begin
                    // Handle rounding if needed
                    if (round_needed) begin
                        z_mantissa <= z_mantissa + 1;
                        if (&z_mantissa) begin // Mantissa overflow
                            z_mantissa <= {1'b1, 23'b0};
                            z_exponent <= z_exponent + 1;
                        end
                    end
                    
                    // Output selection with priority
                    if (a_nan || b_nan) begin
                        z <= nan_out;
                    end else if ((a_inf || b_inf) && (a_zero || b_zero)) begin
                        z <= nan_out;
                    end else if (a_inf || b_inf) begin
                        z <= inf_out;
                    end else if (a_zero || b_zero) begin
                        z <= zero_out;
                    end else if (exp_overflow) begin
                        z <= inf_out;
                    end else if (exp_underflow) begin
                        z <= zero_out;
                    end else begin
                        z <= normal_out;
                    end
                    
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule