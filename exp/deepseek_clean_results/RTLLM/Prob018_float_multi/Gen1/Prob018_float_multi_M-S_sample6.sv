module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Special case detection (combinational)
    wire a_is_nan = &a[30:23] && |a[22:0];
    wire b_is_nan = &b[30:23] && |b[22:0];
    wire a_is_inf = &a[30:23] && ~|a[22:0];
    wire b_is_inf = &b[30:23] && ~|b[22:0];
    wire a_is_zero = ~|a[30:23] && ~|a[22:0];
    wire b_is_zero = ~|b[30:23] && ~|b[22:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            // Handle special cases first
            if (a_is_nan || b_is_nan) begin
                z <= 32'h7FC00000; // Canonical NaN
            end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                z <= {a[31] ^ b[31], 8'hFF, 23'h0}; // NaN (inf * 0)
            end else if (a_is_inf || b_is_inf) begin
                z <= {a[31] ^ b[31], 8'hFF, 23'h0}; // Infinity
            end else if (a_is_zero || b_is_zero) begin
                z <= {a[31] ^ b[31], 31'h0}; // Zero
            end else begin
                // Normal case processing
                reg [23:0] a_mantissa = {|a[30:23], a[22:0]};
                reg [23:0] b_mantissa = {|b[30:23], b[22:0]};
                reg [9:0] exponent_sum = {2'b0, a[30:23]} + {2'b0, b[30:23]} - 10'd127;
                
                // Multiply mantissas (24x24 = 48 bits)
                reg [47:0] product = a_mantissa * b_mantissa;
                
                // Normalize and round
                reg norm_shift = ~product[47];
                reg [47:0] product_norm = norm_shift ? product << 1 : product;
                exponent_sum = exponent_sum + norm_shift;
                
                // Round to nearest even
                reg guard = product_norm[22];
                reg round = product_norm[21];
                reg sticky = |product_norm[20:0];
                reg [22:0] mantissa_rounded = product_norm[46:24];
                
                if (guard && (round || sticky || product_norm[23])) begin
                    {exponent_sum, mantissa_rounded} = 
                        (mantissa_rounded == 23'h7FFFFF) ? 
                        {exponent_sum + 1, 23'h0} : 
                        {exponent_sum, mantissa_rounded + 1};
                end
                
                // Handle overflow/underflow
                if (exponent_sum >= 10'd255) begin // Overflow
                    z <= {a[31] ^ b[31], 8'hFF, 23'h0};
                end else if (exponent_sum < 10'd1) begin // Underflow
                    z <= {a[31] ^ b[31], 31'h0};
                end else begin // Normal result
                    z <= {a[31] ^ b[31], exponent_sum[7:0], mantissa_rounded};
                end
            end
        end
    end

endmodule