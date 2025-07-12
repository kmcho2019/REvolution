module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg [1:0] stage;
    reg [31:0] a_reg, b_reg;
    reg a_sign_reg, b_sign_reg;
    reg [7:0] a_exp_reg, b_exp_reg;
    reg [23:0] a_mant_reg, b_mant_reg;
    
    // Clock gating
    wire clk_gated = clk & (|stage | rst);

    // Input decomposition
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_man = a[22:0];
    wire [22:0] b_man = b[22:0];

    // Normalized mantissas with implicit bit
    wire [23:0] a_mant = (a_exp != 0) ? {1'b1, a_man} : {1'b0, a_man};
    wire [23:0] b_mant = (b_exp != 0) ? {1'b1, b_man} : {1'b0, b_man};

    // Combined special case detection
    wire a_nan = (a_exp == 8'hFF) & (|a_man);
    wire b_nan = (b_exp == 8'hFF) & (|b_man);
    wire a_inf = (a_exp == 8'hFF) & (~|a_man);
    wire b_inf = (b_exp == 8'hFF) & (~|b_man);
    wire a_zero = (a_exp == 0) & (~|a_man);
    wire b_zero = (b_exp == 0) & (~|b_man);
    
    wire is_nan = a_nan | b_nan | (a_inf & b_zero) | (b_inf & a_zero);
    wire is_inf = (a_inf | b_inf) & ~is_nan;
    wire is_zero = (a_zero | b_zero) & ~is_nan & ~is_inf;

    // Booth-encoded multiplier (24x24 bits)
    reg [47:0] product;
    always @(*) begin
        product = 0;
        for (integer i = 0; i < 24; i = i+2) begin
            case (b_mant_reg[i+1:i])
                2'b01: product = product + (a_mant_reg << i);
                2'b10: product = product - (a_mant_reg << i);
                2'b11: product = product - (a_mant_reg << (i+1));
            endcase
        end
    end

    // Shared adder for exponent calculations
    reg [8:0] exp_sum;  // Extra bit for overflow detection
    always @(*) begin
        exp_sum = {1'b0, a_exp_reg} + {1'b0, b_exp_reg} - 9'd127;
    end

    // Rounding logic
    wire guard = product[22];
    wire round = product[21];
    wire sticky = |product[20:0];
    wire round_up = guard & (round | sticky | product[23]);

    // Pipeline control
    always @(posedge clk_gated or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
        end else begin
            case (stage)
                0: begin  // Input stage
                    a_reg <= a;
                    b_reg <= b;
                    a_sign_reg <= a_sign;
                    b_sign_reg <= b_sign;
                    a_exp_reg <= a_exp;
                    b_exp_reg <= b_exp;
                    a_mant_reg <= a_mant;
                    b_mant_reg <= b_mant;
                    stage <= 1;
                end
                1: begin  // Multiply stage
                    stage <= 2;
                end
                2: begin  // Normalize/output stage
                    if (is_nan) begin
                        z <= 32'h7FC00000; // NaN
                    end else if (is_inf) begin
                        z <= {a_sign_reg ^ b_sign_reg, 8'hFF, 23'b0}; // Infinity
                    end else if (is_zero) begin
                        z <= {a_sign_reg ^ b_sign_reg, 31'b0}; // Zero
                    end else begin
                        // Normalize and round
                        wire [47:0] rounded_product = round_up ? (product + (1 << 22)) : product;
                        wire product_msb = rounded_product[47];
                        wire [7:0] final_exp = product_msb ? exp_sum[7:0] + 1 : exp_sum[7:0];
                        wire [22:0] final_man = product_msb ? rounded_product[46:24] : rounded_product[45:23];
                        
                        // Overflow/underflow check
                        if (exp_sum[8] | (&final_exp)) begin // Overflow
                            z <= {a_sign_reg ^ b_sign_reg, 8'hFF, 23'b0};
                        end else if (final_exp == 0) begin // Underflow
                            z <= {a_sign_reg ^ b_sign_reg, 31'b0};
                        end else begin
                            z <= {a_sign_reg ^ b_sign_reg, final_exp, final_man};
                        end
                    end
                    stage <= 0;
                end
            endcase
        end
    end

endmodule