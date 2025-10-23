module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Enhanced pipeline stages
    localparam S_EXTRACT = 0;
    localparam S_MULT_LOW = 1;
    localparam S_MULT_HIGH = 2;
    localparam S_NORMALIZE = 3;
    localparam S_OUTPUT = 4;

    reg [2:0] state;
    reg [22:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [46:0] product;  // Reduced to 47 bits (23x23 + rounding)
    reg guard_bit, round_bit, sticky;
    
    // Early special case detection (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    wire special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;
    
    // Clock gating for multiplier
    wire mult_clk_en = (state == S_EXTRACT) | (state == S_MULT_LOW);
    wire mult_clk = clk & mult_clk_en;
    
    // Multiplier registers (split into two stages)
    reg [23:0] mult_a, mult_b;
    reg [23:0] partial_prod;
    
    // Exponent calculation
    wire [8:0] exp_sum = {1'b0, a_exponent} + {1'b0, b_exponent};
    wire [8:0] exp_biased = exp_sum - 9'd127;
    
    // Normalization
    wire product_msb = product[46];
    wire [22:0] norm_mantissa = product_msb ? product[46:24] : product[45:23];
    wire [7:0] norm_exponent = product_msb ? (exp_biased[7:0] + 1) : exp_biased[7:0];
    
    // Simplified rounding
    wire round_inc = guard_bit & (round_bit | sticky);
    
    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {z_sign, 8'hFF, 23'b0};
    wire [31:0] zero_out = {z_sign, 31'b0};
    wire [31:0] normal_out = {z_sign, z_exponent, z_mantissa};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_EXTRACT;
            z <= 0;
        end else begin
            case (state)
                S_EXTRACT: begin
                    // Early special case handling
                    if (special_case) begin
                        if (a_nan | b_nan) z <= nan_out;
                        else if ((a_inf & b_zero) | (b_inf & a_zero)) z <= nan_out;
                        else if (a_inf | b_inf) z <= inf_out;
                        else z <= zero_out;
                        state <= S_EXTRACT;
                    end else begin
                        // Extract components
                        a_sign <= a[31];
                        b_sign <= b[31];
                        a_exponent <= a[30:23];
                        b_exponent <= b[30:23];
                        a_mantissa <= |a[30:23] ? a[22:0] : 23'b0;
                        b_mantissa <= |b[30:23] ? b[22:0] : 23'b0;
                        
                        // Prepare multiplier inputs
                        mult_a <= {|a[30:23], a[22:0]};
                        mult_b <= {|b[30:23], b[22:0]};
                        
                        state <= S_MULT_LOW;
                    end
                end
                
                S_MULT_LOW: begin
                    // First stage of multiplication (lower bits)
                    partial_prod <= mult_a[11:0] * mult_b;
                    state <= S_MULT_HIGH;
                end
                
                S_MULT_HIGH: begin
                    // Second stage of multiplication (upper bits)
                    product <= (mult_a[23:12] * mult_b) << 12 + partial_prod;
                    z_exponent <= exp_biased[7:0];
                    z_sign <= a_sign ^ b_sign;
                    
                    // Pre-compute sticky bit
                    sticky <= |(mult_a[11:0] & mult_b[11:0]);
                    
                    state <= S_NORMALIZE;
                end
                
                S_NORMALIZE: begin
                    // Normalize and round
                    z_mantissa <= norm_mantissa;
                    z_exponent <= norm_exponent;
                    guard_bit <= product[23];
                    round_bit <= product[22];
                    
                    if (round_inc) begin
                        {z_exponent, z_mantissa} <= z_mantissa + 1;
                        if (&z_mantissa) begin // Handle overflow
                            z_exponent <= z_exponent + 1;
                            z_mantissa <= 23'b0;
                        end
                    end
                    
                    state <= S_OUTPUT;
                end
                
                S_OUTPUT: begin
                    // Final output with overflow checks
                    if (&z_exponent) z <= inf_out; // Overflow
                    else if (z_exponent == 0) z <= zero_out; // Underflow
                    else z <= normal_out;
                    
                    state <= S_EXTRACT;
                end
            endcase
        end
    end

endmodule