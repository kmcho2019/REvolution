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
    reg [8:0] a_exponent, b_exponent, z_exponent; // Reduced to 9 bits
    reg a_sign, b_sign, z_sign;
    reg [47:0] product; // Reduced to 48 bits
    reg guard_bit, round_bit, sticky;
    
    // Pipeline registers for multiplier
    reg [23:0] mul_a, mul_b;
    reg [11:0] pp0, pp1, pp2, pp3; // Partial products
    
    // Combined special case detection
    wire special_case = (a[30:0] == 0) || (b[30:0] == 0) || // Zero
                       (&a[30:23] || &b[30:23]); // NaN or Infinity
    
    wire a_nan = &a[30:23] && |a[22:0];
    wire b_nan = &b[30:23] && |b[22:0];
    wire any_nan = a_nan || b_nan;
    wire any_inf = (&a[30:23] && (a[22:0] == 0)) || (&b[30:23] && (b[22:0] == 0));
    wire any_zero = (a[30:0] == 0) || (b[30:0] == 0);
    
    // Exponent calculation (registered)
    reg [8:0] exp_sum, exp_biased;
    wire [8:0] exp_sum_next = a_exponent + b_exponent;
    wire [8:0] exp_biased_next = exp_sum - 9'd127;
    
    // Sign calculation
    wire sign_result = a_sign ^ b_sign;
    
    // Normalization signals
    wire [23:0] norm_mantissa = product[47] ? product[47:24] : product[46:23];
    wire [8:0] norm_exponent = product[47] ? (exp_biased + 1) : exp_biased;
    
    // Rounding logic (clock gated)
    wire round_en = (state == NORM);
    wire round_inc = round_en && guard_bit && (round_bit || sticky || z_mantissa[0]);
    
    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {sign_result, 8'hFF, 23'b0};
    wire [31:0] zero_out = {sign_result, 31'b0};
    wire [31:0] normal_out = {sign_result, z_exponent[7:0], z_mantissa[22:0]};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 0;
            product <= 0;
            exp_sum <= 0;
            exp_biased <= 0;
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
                    
                    // Pre-calculate exponents
                    exp_sum <= exp_sum_next;
                    exp_biased <= exp_biased_next;
                    
                    state <= MUL_STG1;
                end
                
                MUL_STG1: begin
                    // Stage 1: Partial product generation
                    mul_a <= a_mantissa;
                    mul_b <= b_mantissa;
                    pp0 <= a_mantissa[11:0] * b_mantissa[11:0];
                    pp1 <= a_mantissa[23:12] * b_mantissa[11:0];
                    pp2 <= a_mantissa[11:0] * b_mantissa[23:12];
                    pp3 <= a_mantissa[23:12] * b_mantissa[23:12];
                    
                    state <= MUL_STG2;
                end
                
                MUL_STG2: begin
                    // Stage 2: Final addition
                    product <= (pp3 << 24) + (pp2 << 12) + (pp1 << 12) + pp0;
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
                    // Handle special cases with priority
                    if (any_nan) begin
                        z <= nan_out;
                    end else if (any_inf && any_zero) begin
                        z <= nan_out;
                    end else if (any_inf) begin
                        z <= inf_out;
                    end else if (any_zero) begin
                        z <= zero_out;
                    end else if (&z_exponent[7:0] || z_exponent[8]) begin // Overflow
                        z <= inf_out;
                    end else if (z_exponent == 0) begin // Underflow
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