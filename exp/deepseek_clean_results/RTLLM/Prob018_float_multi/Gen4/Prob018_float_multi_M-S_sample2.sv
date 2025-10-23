module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage control
    reg stage;
    
    // Internal signals
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [23:0] a_man, b_man;
    reg [47:0] product;
    reg [7:0] exp_sum;
    
    // Special case flags
    wire a_is_nan = &a[30:23] && |a[22:0];
    wire b_is_nan = &b[30:23] && |b[22:0];
    wire a_is_inf = &a[30:23] && ~|a[22:0];
    wire b_is_inf = &b[30:23] && ~|b[22:0];
    wire a_is_zero = ~|a[30:0];
    wire b_is_zero = ~|b[30:0];
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
        end else begin
            case (stage)
                0: begin // Stage 0: Input processing
                    // Handle special cases first
                    if (a_is_nan || b_is_nan) begin
                        z <= 32'h7FC00000; // Canonical NaN
                        stage <= 0;
                    end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                        z <= 32'h7FC00000; // NaN for inf*0
                        stage <= 0;
                    end else if (a_is_inf || b_is_inf) begin
                        z <= {a[31] ^ b[31], 8'hFF, 23'h0}; // Infinity
                        stage <= 0;
                    end else if (a_is_zero || b_is_zero) begin
                        z <= {a[31] ^ b[31], 31'h0}; // Zero
                        stage <= 0;
                    end else begin
                        // Normal numbers processing
                        a_sign <= a[31];
                        b_sign <= b[31];
                        a_exp <= a[30:23];
                        b_exp <= b[30:23];
                        a_man <= {1'b1, a[22:0]}; // Add implicit 1
                        b_man <= {1'b1, b[22:0]}; // Add implicit 1
                        exp_sum <= a[30:23] + b[30:23] - 8'd127; // Exponent sum
                        stage <= 1;
                    end
                end
                
                1: begin // Stage 1: Multiplication and normalization
                    // Multiply mantissas
                    product = a_man * b_man;
                    
                    // Normalize result
                    if (product[47]) begin
                        product = product >> 1;
                        exp_sum = exp_sum + 1;
                    end
                    
                    // Round to nearest even
                    if (product[22] && (product[21] || |product[20:0])) begin
                        product[46:23] = product[46:23] + 1;
                        if (product[47]) begin // Handle carry from rounding
                            product = product >> 1;
                            exp_sum = exp_sum + 1;
                        end
                    end
                    
                    // Check for overflow/underflow
                    if (exp_sum[7] || (&exp_sum)) begin // Underflow or overflow
                        z <= exp_sum[7] ? {a_sign ^ b_sign, 31'h0} : {a_sign ^ b_sign, 8'hFF, 23'h0};
                    end else begin
                        z <= {a_sign ^ b_sign, exp_sum, product[45:23]};
                    end
                    stage <= 0;
                end
            endcase
        end
    end

endmodule