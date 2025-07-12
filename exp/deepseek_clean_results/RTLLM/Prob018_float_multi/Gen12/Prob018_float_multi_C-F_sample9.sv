module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stages
    localparam S_EXTRACT = 0;
    localparam S_MULTIPLY = 1;
    localparam S_OUTPUT = 2;

    reg [1:0] state;
    reg [23:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg a_sign, b_sign;
    
    // Pipeline registers
    reg [47:0] product_reg;
    reg [8:0] exp_sum_reg;
    reg sign_reg;
    reg is_special_case;
    reg [31:0] special_result;
    
    // Special case detection (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    
    // Early special case result calculation
    wire [31:0] early_nan = 32'h7FC00000;
    wire [31:0] early_inf = {a_sign ^ b_sign, 8'hFF, 23'b0};
    wire [31:0] early_zero = {a_sign ^ b_sign, 31'b0};
    
    // Normal operation calculations
    wire [8:0] exp_sum = {1'b0, a_exponent} + {1'b0, b_exponent} - 9'd127;
    wire product_msb = product_reg[47];
    wire [22:0] norm_mantissa = product_msb ? product_reg[46:24] : product_reg[45:23];
    wire [8:0] norm_exponent = product_msb ? (exp_sum_reg + 1) : exp_sum_reg;
    
    // Rounding (round to nearest even)
    wire round_inc = product_reg[23] && (product_reg[22] || (|product_reg[21:0]) || norm_mantissa[0]);
    wire [22:0] final_mantissa = round_inc ? norm_mantissa + 1 : norm_mantissa;
    wire [8:0] final_exponent = (round_inc && &norm_mantissa) ? norm_exponent + 1 : norm_exponent;
    
    // Final output selection
    wire [31:0] normal_result = {sign_reg, final_exponent[7:0], final_mantissa};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_EXTRACT;
            z <= 0;
            is_special_case <= 0;
        end else begin
            case (state)
                S_EXTRACT: begin
                    // Check for special cases early
                    if (a_nan || b_nan) begin
                        is_special_case <= 1;
                        special_result <= early_nan;
                    end
                    else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        is_special_case <= 1;
                        special_result <= early_nan;
                    end
                    else if (a_inf || b_inf) begin
                        is_special_case <= 1;
                        special_result <= early_inf;
                    end
                    else if (a_zero || b_zero) begin
                        is_special_case <= 1;
                        special_result <= early_zero;
                    end
                    else begin
                        // Extract components for normal operation
                        a_sign <= a[31];
                        b_sign <= b[31];
                        a_exponent <= a[30:23];
                        b_exponent <= b[30:23];
                        a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                        b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                        is_special_case <= 0;
                    end
                    
                    state <= S_MULTIPLY;
                end
                
                S_MULTIPLY: begin
                    if (is_special_case) begin
                        z <= special_result;
                        state <= S_EXTRACT;
                    end else begin
                        // Perform multiplication and register results
                        product_reg <= a_mantissa * b_mantissa;
                        exp_sum_reg <= exp_sum;
                        sign_reg <= a_sign ^ b_sign;
                        state <= S_OUTPUT;
                    end
                end
                
                S_OUTPUT: begin
                    // Handle normal operation results
                    if (final_exponent[8] || &final_exponent[7:0]) begin // Overflow
                        z <= {sign_reg, 8'hFF, 23'b0};
                    end
                    else if (final_exponent == 0) begin // Underflow
                        z <= {sign_reg, 31'b0};
                    end
                    else begin
                        z <= normal_result;
                    end
                    
                    state <= S_EXTRACT;
                end
            endcase
        end
    end

endmodule