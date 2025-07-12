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
    
    // Calculation registers
    reg [8:0] exp_sum;
    reg [47:0] product;
    reg guard, round, sticky;
    
    // State tracking
    reg stage;

    // Special case detection (combinational)
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
            stage <= 0;
        end else begin
            case (stage)
                0: begin // Stage 1: Input processing
                    a_reg <= a;
                    b_reg <= b;
                    
                    if (any_nan || inf_times_zero) begin
                        z <= {1'b0, 8'hFF, 23'h400000}; // qNaN
                        stage <= 0;
                    end else if (a_is_inf || b_is_inf) begin
                        z <= {a[31] ^ b[31], 8'hFF, 23'h0}; // Inf
                        stage <= 0;
                    end else if (a_is_zero || b_is_zero) begin
                        z <= {a[31] ^ b[31], 31'h0}; // Zero
                        stage <= 0;
                    end else begin
                        a_sign <= a[31];
                        b_sign <= b[31];
                        a_exp <= a[30:23];
                        b_exp <= b[30:23];
                        a_man <= |a[30:23] ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                        b_man <= |b[30:23] ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                        stage <= 1;
                    end
                end
                
                1: begin // Stage 2: Calculation
                    // Calculate exponent
                    exp_sum <= a_exp + b_exp - 127;
                    
                    // Multiply mantissas
                    product <= a_man * b_man;
                    
                    // Normalize
                    if (product[47]) begin
                        product <= product >> 1;
                        exp_sum <= exp_sum + 1;
                    end
                    
                    // Round to nearest even
                    guard <= product[22];
                    round <= product[21];
                    sticky <= |product[20:0];
                    
                    if (guard && (round || sticky || product[23])) begin
                        product <= product + (1 << 23);
                        if (product[47]) begin
                            product <= product >> 1;
                            exp_sum <= exp_sum + 1;
                        end
                    end
                    
                    // Check for overflow/underflow
                    if (exp_sum[8] || exp_sum[7:0] == 8'hFF) begin
                        z <= exp_sum[8] ? {a_sign ^ b_sign, 31'h0} : {a_sign ^ b_sign, 8'hFF, 23'h0};
                    end else begin
                        z <= {a_sign ^ b_sign, exp_sum[7:0], product[46:24]};
                    end
                    
                    stage <= 0;
                end
            endcase
        end
    end

endmodule