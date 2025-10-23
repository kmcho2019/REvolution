module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Internal signals
    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exp, b_exp, z_exp;
    reg [23:0] a_man, b_man, z_man;
    reg [47:0] product;
    reg [7:0] exp_sum;
    reg [4:0] leading_zeros;
    reg guard, round, sticky;

    // Special case flags
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (a[30:23] == 8'hFF) & (a[22:0] == 0);
    wire b_inf = (b[30:23] == 8'hFF) & (b[22:0] == 0);
    wire a_nan = (a[30:23] == 8'hFF) & (a[22:0] != 0);
    wire b_nan = (b[30:23] == 8'hFF) & (b[22:0] != 0);
    wire result_nan = a_nan | b_nan | (a_zero & b_inf) | (a_inf & b_zero);
    wire result_inf = (a_inf | b_inf) & ~result_nan;
    wire result_zero = (a_zero | b_zero) & ~result_nan;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            // Extract components
            a_sign <= a[31];
            b_sign <= b[31];
            a_exp <= a[30:23];
            b_exp <= b[30:23];
            a_man <= (a_exp == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            b_man <= (b_exp == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

            // Special cases
            if (result_nan) begin
                z <= {1'b0, 8'hFF, 23'h7FFFFF}; // Canonical NaN
            end else if (result_inf) begin
                z <= {a_sign ^ b_sign, 8'hFF, 23'h0};
            end else if (result_zero) begin
                z <= {a_sign ^ b_sign, 31'h0};
            end else begin
                // Multiply mantissas
                product <= a_man * b_man;

                // Calculate exponent
                exp_sum <= a_exp + b_exp - 127;

                // Count leading zeros (simplified)
                leading_zeros <= 0;
                for (integer i = 47; i >= 0; i = i-1) begin
                    if (product[i] && leading_zeros == 0) begin
                        leading_zeros <= 47 - i;
                    end
                end

                // Normalize
                if (product[47]) begin
                    z_man <= product[46:23];
                    z_exp <= exp_sum + 1;
                end else begin
                    z_man <= product[45:22] << (leading_zeros + 1);
                    z_exp <= exp_sum - leading_zeros;
                end

                // Rounding bits
                guard <= product[22];
                round <= product[21];
                sticky <= |product[20:0];

                // Round to nearest even
                if (guard && (round || sticky || z_man[0])) begin
                    z_man <= z_man + 1;
                    if (z_man == 24'hFFFFFF) begin // Handle overflow
                        z_man <= 24'h800000;
                        z_exp <= z_exp + 1;
                    end
                end

                // Check for overflow/underflow
                if (z_exp > 254) begin
                    z <= {a_sign ^ b_sign, 8'hFF, 23'h0}; // Infinity
                end else if (z_exp < 1) begin
                    z <= {a_sign ^ b_sign, 31'h0}; // Zero
                end else begin
                    z <= {a_sign ^ b_sign, z_exp, z_man[22:0]};
                end
            end
        end
    end

endmodule