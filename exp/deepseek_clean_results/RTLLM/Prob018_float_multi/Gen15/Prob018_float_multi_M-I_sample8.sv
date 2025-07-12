module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // One-hot state encoding
    localparam EXTRACT  = 5'b00001;
    localparam MUL_PP   = 5'b00010;  // Partial products
    localparam MUL_SUM  = 5'b00100;  // Final sum
    localparam NORMALIZE = 5'b01000;
    localparam OUTPUT   = 5'b10000;

    reg [4:0] state;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0] a_exponent, b_exponent, z_exponent; // Reduced to 8 bits
    reg a_sign, b_sign, z_sign;
    reg [46:0] product;  // Reduced to 47 bits
    reg guard_bit, round_bit, sticky;
    reg exp_ovf, exp_unf; // Explicit overflow/underflow flags
    
    // Clock gating signals
    wire mul_clk_en = (state == MUL_PP) || (state == MUL_SUM);
    wire mul_clk = clk & mul_clk_en;
    
    // Special case flags (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    
    // Multiplier pipeline registers
    reg [23:0] a_mantissa_mul, b_mantissa_mul;
    reg [23:0] partial_products [11:0];
    reg [47:0] product_sum;
    
    // Early rounding computation
    wire round_inc;
    reg round_inc_reg;
    
    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {z_sign, 8'hFF, 23'b0};
    wire [31:0] zero_out = {z_sign, 31'b0};
    wire [31:0] normal_out = {z_sign, z_exponent[7:0], z_mantissa[22:0]};

    // Multiplier pipeline stage 1: Partial products
    always @(posedge mul_clk or posedge rst) begin
        if (rst) begin
            for (integer i = 0; i < 12; i = i+1)
                partial_products[i] <= 0;
        end else if (state == MUL_PP) begin
            a_mantissa_mul <= a_mantissa;
            b_mantissa_mul <= b_mantissa;
            // Generate partial products
            for (integer i = 0; i < 12; i = i+1)
                partial_products[i] <= a_mantissa & {24{b_mantissa[i*2 +: 2]}};
        end
    end

    // Multiplier pipeline stage 2: Sum partial products
    always @(posedge mul_clk or posedge rst) begin
        if (rst) begin
            product_sum <= 0;
        end else if (state == MUL_SUM) begin
            product_sum <= partial_products[0] + (partial_products[1] << 1) + 
                         (partial_products[2] << 2) + (partial_products[3] << 3) +
                         // ... sum all partial products
                         (partial_products[11] << 11);
        end
    end

    // Main state machine
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= EXTRACT;
            z <= 0;
        end else begin
            case (state)
                EXTRACT: begin
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    state <= MUL_PP;
                end
                
                MUL_PP: begin
                    state <= MUL_SUM;
                end
                
                MUL_SUM: begin
                    product <= product_sum[46:0];
                    z_exponent <= a_exponent + b_exponent - 8'd127;
                    z_sign <= a_sign ^ b_sign;
                    exp_ovf <= (a_exponent + b_exponent) > 8'd254;
                    exp_unf <= (a_exponent + b_exponent) < 8'd127;
                    
                    state <= NORMALIZE;
                end
                
                NORMALIZE: begin
                    if (product[46]) begin
                        z_mantissa <= product[46:23];
                        z_exponent <= z_exponent + 1;
                    end else begin
                        z_mantissa <= product[45:22];
                    end
                    
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    sticky <= |product[20:0];
                    round_inc_reg <= guard_bit && (round_bit || sticky || z_mantissa[0]);
                    
                    state <= OUTPUT;
                end
                
                OUTPUT: begin
                    if (round_inc_reg) begin
                        {exp_ovf, z_mantissa} <= z_mantissa + 1;
                        if (exp_ovf) z_exponent <= z_exponent + 1;
                    end
                    
                    // Output selection (pipelined)
                    if (a_nan || b_nan) z <= nan_out;
                    else if ((a_inf || b_inf) && (a_zero || b_zero)) z <= nan_out;
                    else if (a_inf || b_inf) z <= inf_out;
                    else if (a_zero || b_zero) z <= zero_out;
                    else if (exp_ovf || &z_exponent) z <= inf_out;
                    else if (exp_unf || (z_exponent == 0)) z <= zero_out;
                    else z <= normal_out;
                    
                    state <= EXTRACT;
                end
            endcase
        end
    end

endmodule