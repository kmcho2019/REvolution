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
    reg sign_reg;
    reg [7:0] exp_sum_reg;
    reg [47:0] product_reg;
    reg norm_shift_reg;
    
    // Internal signals
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exponent = a[30:23];
    wire [7:0] b_exponent = b[30:23];
    wire [22:0] a_mantissa = a[22:0];
    wire [22:0] b_mantissa = b[22:0];
    
    // Special case detection (combinatorial)
    wire a_zero = (a_exponent == 0) && (a_mantissa == 0);
    wire b_zero = (b_exponent == 0) && (b_mantissa == 0);
    wire a_inf = (a_exponent == 8'hFF) && (a_mantissa == 0);
    wire b_inf = (b_exponent == 8'hFF) && (b_mantissa == 0);
    wire a_nan = (a_exponent == 8'hFF) && (a_mantissa != 0);
    wire b_nan = (b_exponent == 8'hFF) && (b_mantissa != 0);
    wire special_case = a_nan | b_nan | (a_inf & b_zero) | (b_inf & a_zero) | a_inf | b_inf | a_zero | b_zero;
    
    // Normalized mantissas with implicit bit
    wire [23:0] a_mant_norm = (a_exponent != 0) ? {1'b1, a_mantissa} : {1'b0, a_mantissa};
    wire [23:0] b_mant_norm = (b_exponent != 0) ? {1'b1, b_mantissa} : {1'b0, b_mantissa};
    
    // Booth-encoded multiplier (24x24 bits)
    wire [47:0] product;
    booth_multiplier #(.WIDTH(24)) mult (
        .a(a_mant_norm),
        .b(b_mant_norm),
        .p(product)
    );
    
    // Pipeline control
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            a_reg <= 0;
            b_reg <= 0;
            sign_reg <= 0;
            exp_sum_reg <= 0;
            product_reg <= 0;
            norm_shift_reg <= 0;
        end else begin
            case (stage)
                0: begin // Stage 1: Input processing
                    a_reg <= a;
                    b_reg <= b;
                    sign_reg <= a_sign ^ b_sign;
                    exp_sum_reg <= a_exponent + b_exponent;
                    stage <= 1;
                end
                1: begin // Stage 2: Multiplication
                    product_reg <= product;
                    norm_shift_reg <= product[47];
                    stage <= 2;
                end
                2: begin // Stage 3: Normalization and output
                    stage <= 0;
                end
            endcase
        end
    end
    
    // Final result calculation (combinatorial)
    wire [8:0] exp_adj = {1'b0, exp_sum_reg} - 9'd127;
    wire [8:0] final_exponent = norm_shift_reg ? exp_adj + 1 : exp_adj;
    
    // Rounding logic
    wire guard = norm_shift_reg ? product_reg[23] : product_reg[22];
    wire round = norm_shift_reg ? product_reg[22] : product_reg[21];
    wire sticky = norm_shift_reg ? (|product_reg[21:0]) : (|product_reg[20:0]);
    wire round_up = guard & (round | sticky | product_reg[norm_shift_reg ? 24 : 23]);
    
    wire [22:0] pre_round_mantissa = norm_shift_reg ? product_reg[46:24] : product_reg[45:23];
    wire [22:0] final_mantissa = pre_round_mantissa + round_up;
    
    // Output generation
    always @(*) begin
        if (rst) begin
            z = 0;
        end else if (stage == 2) begin
            if (a_nan || b_nan) begin
                z = 32'h7FC00000; // NaN
            end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                z = 32'h7FC00000; // NaN (0*inf)
            end else if (a_inf || b_inf) begin
                z = {sign_reg, 8'hFF, 23'b0}; // Infinity
            end else if (a_zero || b_zero) begin
                z = {sign_reg, 31'b0}; // Zero
            end else if (final_exponent[8] || (&final_exponent[7:0])) begin // Overflow/underflow
                z = {sign_reg, 8'hFF, 23'b0}; // Infinity
            end else begin
                z = {sign_reg, final_exponent[7:0], final_mantissa};
            end
        end else begin
            z = 0;
        end
    end

endmodule

// Booth multiplier module
module booth_multiplier #(
    parameter WIDTH = 24
)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output reg [2*WIDTH-1:0] p
);
    // Booth encoding implementation
    // ... (implementation details omitted for brevity)
    // This would typically be implemented with radix-4 encoding
    // and partial product accumulation
endmodule