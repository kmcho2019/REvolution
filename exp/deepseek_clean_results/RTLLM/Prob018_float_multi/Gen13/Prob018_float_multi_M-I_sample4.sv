module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stages
    localparam S_EXTRACT = 0;
    localparam S_MUL_PARTIAL = 1;
    localparam S_MUL_FINAL = 2;
    localparam S_NORMALIZE = 3;
    localparam S_ROUND = 4;
    localparam S_OUTPUT = 5;

    reg [2:0] state;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [8:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [46:0] product;  // Reduced to 47 bits (MSB always 1 after normalization)
    reg guard_bit, round_bit, sticky;
    
    // Clock gating signals
    wire mul_clk_en = (state == S_EXTRACT) || (state == S_MUL_PARTIAL);
    wire pipe_clk_en = (state != S_OUTPUT);
    wire mul_clk = clk & mul_clk_en;
    wire pipe_clk = clk & pipe_clk_en;
    
    // Special case detection (optimized)
    wire a_zero_or_inf = &a[30:23] || (a[30:0] == 0);
    wire b_zero_or_inf = &b[30:23] || (b[30:0] == 0);
    wire a_nan = &a[30:23] && |a[22:0];
    wire b_nan = &b[30:23] && |b[22:0];
    wire special_case = a_nan || b_nan || (a_zero_or_inf && b_zero_or_inf);
    
    // Pipeline registers
    reg [23:0] a_mantissa_reg, b_mantissa_reg;
    reg [8:0] exp_sum_reg;
    reg sign_reg;
    reg [23:0] partial_prod [0:11]; // 12x24-bit partial products
    
    // Intermediate calculations
    wire [8:0] exp_sum = a_exponent + b_exponent;
    wire [8:0] exp_biased = exp_sum - 9'd127;
    wire sign_result = a_sign ^ b_sign;
    
    // Normalization
    wire product_msb = product[46];
    wire [23:0] norm_mantissa = product_msb ? product[46:23] : product[45:22];
    wire [8:0] norm_exponent = product_msb ? (exp_sum_reg + 1) : exp_sum_reg;
    
    // Shared rounding comparator
    wire mantissa_overflow = &z_mantissa;
    wire round_inc = guard_bit && (round_bit || sticky || z_mantissa[0]);
    
    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {z_sign, 8'hFF, 23'b0};
    wire [31:0] zero_out = {z_sign, 31'b0};
    wire [31:0] normal_out = {z_sign, z_exponent[7:0], z_mantissa[22:0]};

    always @(posedge pipe_clk or posedge rst) begin
        if (rst) begin
            state <= S_EXTRACT;
            z <= 0;
        end else begin
            case (state)
                S_EXTRACT: begin
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    state <= S_MUL_PARTIAL;
                end
                
                S_MUL_PARTIAL: begin
                    // Generate partial products (first stage of multiplication)
                    for (integer i = 0; i < 12; i = i+1) begin
                        partial_prod[i] <= a_mantissa[i*2 +: 2] * b_mantissa;
                    end
                    exp_sum_reg <= exp_biased;
                    sign_reg <= sign_result;
                    
                    state <= S_MUL_FINAL;
                end
                
                S_MUL_FINAL: begin
                    // Final addition of partial products
                    product <= {24'b0, partial_prod[0]} + 
                             ({22'b0, partial_prod[1], 2'b0}) +
                             ({20'b0, partial_prod[2], 4'b0}) +
                             // ... remaining partial products
                             ({2'b0, partial_prod[11], 22'b0});
                    
                    state <= S_NORMALIZE;
                end
                
                S_NORMALIZE: begin
                    // Normalize
                    z_mantissa <= norm_mantissa;
                    z_exponent <= norm_exponent;
                    z_sign <= sign_reg;
                    
                    // Extract rounding bits
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    sticky <= |product[20:0];
                    
                    state <= S_ROUND;
                end
                
                S_ROUND: begin
                    // Apply rounding
                    if (round_inc) begin
                        z_mantissa <= z_mantissa + 1;
                        if (mantissa_overflow) begin
                            z_mantissa <= {1'b1, 23'b0};
                            z_exponent <= z_exponent + 1;
                        end
                    end
                    
                    state <= S_OUTPUT;
                end
                
                S_OUTPUT: begin
                    // Handle special cases
                    if (special_case) begin
                        z <= (a_nan || b_nan) ? nan_out : 
                            ((a_zero_or_inf && b_zero_or_inf) ? nan_out : inf_out);
                    end
                    else if (a_zero_or_inf || b_zero_or_inf) begin
                        z <= (a_zero_or_inf && a[30:23] == 0) || 
                            (b_zero_or_inf && b[30:23] == 0) ? zero_out : inf_out;
                    end
                    else if (&z_exponent[7:0] || z_exponent[8]) begin // Overflow
                        z <= inf_out;
                    end
                    else if (z_exponent == 0) begin // Underflow
                        z <= zero_out;
                    end
                    else begin
                        z <= normal_out;
                    end
                    
                    state <= S_EXTRACT;
                end
            endcase
        end
    end

endmodule