module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Input registers
    reg [31:0] a_reg, b_reg;
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [23:0] a_man, b_man;

    // Special case flags
    wire a_is_nan = &a[30:23] && |a[22:0];
    wire b_is_nan = &b[30:23] && |b[22:0];
    wire a_is_inf = &a[30:23] && ~|a[22:0];
    wire b_is_inf = &b[30:23] && ~|b[22:0];
    wire a_is_zero = ~|a[30:0];
    wire b_is_zero = ~|b[30:0];
    wire any_nan = a_is_nan || b_is_nan;
    wire inf_times_zero = (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            // Stage 1: Input processing and special cases
            a_reg <= a;
            b_reg <= b;
            
            // Handle special cases with priority
            if (any_nan || inf_times_zero) begin
                z <= {1'b0, 8'hFF, 23'h400000}; // qNaN
            end else if (a_is_inf || b_is_inf) begin
                z <= {a[31] ^ b[31], 8'hFF, 23'h0}; // Inf
            end else if (a_is_zero || b_is_zero) begin
                z <= {a[31] ^ b[31], 31'h0}; // Zero
            end else begin
                // Stage 2: Normal operation
                a_sign <= a[31];
                b_sign <= b[31];
                a_exp <= a[30:23];
                b_exp <= b[30:23];
                a_man <= |a[30:23] ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                b_man <= |b[30:23] ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                
                // Calculate exponent (bias adjustment)
                reg [8:0] exp_sum = a_exp + b_exp - 127;
                
                // Multiply mantissas (24x24 -> 48 bits)
                reg [47:0] product = a_man * b_man;
                
                // Normalize and round
                if (product[47]) begin
                    product = product >> 1;
                    exp_sum = exp_sum + 1;
                end
                
                // Round to nearest even
                reg guard = product[22];
                reg round = product[21];
                reg sticky = |product[20:0];
                if (guard && (round || sticky || product[23])) begin
                    product[47:24] = product[47:24] + 1;
                    if (product[47]) begin
                        product = product >> 1;
                        exp_sum = exp_sum + 1;
                    end
                end
                
                // Check for overflow/underflow
                if (exp_sum[8] || exp_sum[7:0] == 8'hFF) begin // Underflow or overflow
                    z <= exp_sum[8] ? {a_sign ^ b_sign, 31'h0} : {a_sign ^ b_sign, 8'hFF, 23'h0};
                end else begin
                    z <= {a_sign ^ b_sign, exp_sum[7:0], product[46:24]};
                end
            end
        end
    end

endmodule