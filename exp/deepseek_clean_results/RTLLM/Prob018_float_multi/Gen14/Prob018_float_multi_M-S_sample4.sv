module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            // Extract components
            wire a_sign = a[31];
            wire b_sign = b[31];
            wire [7:0] a_exp = a[30:23];
            wire [7:0] b_exp = b[30:23];
            wire [23:0] a_man = (a_exp != 0) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
            wire [23:0] b_man = (b_exp != 0) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
            
            // Special cases
            wire a_nan = (a_exp == 8'hFF) && (a[22:0] != 0);
            wire b_nan = (b_exp == 8'hFF) && (b[22:0] != 0);
            wire a_inf = (a_exp == 8'hFF) && (a[22:0] == 0);
            wire b_inf = (b_exp == 8'hFF) && (b[22:0] == 0);
            wire a_zero = (a_exp == 0) && (a[22:0] == 0);
            wire b_zero = (b_exp == 0) && (b[22:0] == 0);
            
            // Handle special cases with priority
            if (a_nan || b_nan) begin
                z <= 32'h7FC00000; // NaN
            end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                z <= 32'h7FC00000; // 0*inf = NaN
            end else if (a_inf || b_inf) begin
                z <= {a_sign ^ b_sign, 8'hFF, 23'b0}; // Infinity
            end else if (a_zero || b_zero) begin
                z <= {a_sign ^ b_sign, 31'b0}; // Zero
            end else begin
                // Normal case
                wire [47:0] product = a_man * b_man;
                wire [7:0] exp_sum = a_exp + b_exp - 8'd127;
                wire norm = product[47];
                
                if (exp_sum > 8'hFD || (exp_sum == 8'hFD && norm)) begin
                    z <= {a_sign ^ b_sign, 8'hFF, 23'b0}; // Overflow
                end else begin
                    z <= {a_sign ^ b_sign, 
                          norm ? exp_sum + 1 : exp_sum, 
                          norm ? product[46:24] : product[45:23]};
                end
            end
        end
    end

endmodule