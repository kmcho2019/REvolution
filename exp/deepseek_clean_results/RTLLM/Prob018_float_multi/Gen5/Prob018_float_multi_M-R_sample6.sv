module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg stage;
    reg [31:0] a_reg, b_reg;
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [23:0] a_man, b_man;
    
    // Continuous assignments for special cases
    wire a_is_nan = &a[30:23] && |a[22:0];
    wire b_is_nan = &b[30:23] && |b[22:0];
    wire a_is_inf = &a[30:23] && ~|a[22:0];
    wire b_is_inf = &b[30:23] && ~|b[22:0];
    wire a_is_zero = ~|a[30:23] && ~|a[22:0];
    wire b_is_zero = ~|b[30:23] && ~|b[22:0];
    wire any_nan = a_is_nan || b_is_nan;
    wire inf_times_zero = (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);
    
    // Combinational intermediate results
    wire [7:0] exp_sum = a_exp + b_exp;
    wire [7:0] exp_biased = exp_sum - 8'd127;
    wire exp_overflow = (exp_sum > 8'd254);
    wire exp_underflow = (exp_sum < 8'd127);
    wire sign_result = a_sign ^ b_sign;
    
    // Multiplication stage
    wire [47:0] product = a_man * b_man;
    wire product_msb = product[47];
    wire [47:0] normalized = product_msb ? product >> 1 : product;
    wire [7:0] final_exp = product_msb ? exp_biased + 1 : exp_biased;
    
    // Rounding logic
    wire guard = normalized[22];
    wire round = normalized[21];
    wire sticky = |normalized[20:0];
    wire round_up = guard && (round || sticky);
    wire [47:0] rounded = round_up ? normalized[47:23] + 1 : normalized[47:23];
    wire rounding_overflow = rounded[24];
    wire [22:0] final_mantissa = rounding_overflow ? 
                               {rounded[23:1]} : rounded[22:0];
    wire [7:0] adjusted_exp = rounding_overflow ? 
                            final_exp + 1 : final_exp;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
            a_reg <= 0;
            b_reg <= 0;
        end else begin
            case (stage)
                0: begin // Decode stage
                    a_reg <= a;
                    b_reg <= b;
                    
                    // Handle special cases immediately
                    if (any_nan) begin
                        z <= {1'b0, 8'hFF, 23'h400000}; // qNaN
                    end else if (inf_times_zero) begin
                        z <= {1'b0, 8'hFF, 23'h400000}; // qNaN
                    end else if (a_is_inf || b_is_inf) begin
                        z <= {sign_result, 8'hFF, 23'h0}; // Inf
                    end else if (a_is_zero || b_is_zero) begin
                        z <= {sign_result, 31'h0}; // Zero
                    end else begin
                        // Extract components for next stage
                        a_sign <= a[31];
                        b_sign <= b[31];
                        a_exp <= a[30:23];
                        b_exp <= b[30:23];
                        a_man <= |a[30:23] ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                        b_man <= |b[30:23] ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                        stage <= 1;
                    end
                end
                
                1: begin // Execute stage
                    // Handle normal case with overflow/underflow
                    if (exp_overflow || (&adjusted_exp)) begin
                        z <= {sign_result, 8'hFF, 23'h0}; // Overflow to inf
                    end else if (exp_underflow || (adjusted_exp[7] && adjusted_exp != 8'h0)) begin
                        z <= {sign_result, 31'h0}; // Underflow to zero
                    end else begin
                        z <= {sign_result, adjusted_exp, final_mantissa};
                    end
                    stage <= 0;
                end
            endcase
        end
    end

endmodule