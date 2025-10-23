module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Special case detection
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);

    // Sign calculation
    wire sign = a[31] ^ b[31];

    // Mantissa calculation
    wire [23:0] a_mant = (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
    wire [23:0] b_mant = (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
    wire [47:0] product = a_mant * b_mant;

    // Exponent calculation
    wire [8:0] exp_sum = {1'b0, a[30:23]} + {1'b0, b[30:23]} - 9'd127;
    
    // Normalization
    wire product_msb = product[47];
    wire [23:0] norm_mant = product_msb ? product[47:24] : product[46:23];
    wire [8:0] norm_exp = product_msb ? (exp_sum + 1) : exp_sum;
    
    // Basic rounding (round to nearest even)
    wire round = norm_mant[0] & (product[22] | (|product[21:0]));
    wire [23:0] final_mant = norm_mant + round;
    wire [8:0] final_exp = (&norm_mant && round) ? norm_exp + 1 : norm_exp;

    // Output selection
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            if (a_nan || b_nan) begin
                z <= 32'h7FC00000; // NaN
            end
            else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                z <= 32'h7FC00000; // NaN
            end
            else if (a_inf || b_inf) begin
                z <= {sign, 8'hFF, 23'b0}; // Infinity
            end
            else if (a_zero || b_zero) begin
                z <= {sign, 31'b0}; // Zero
            end
            else if (final_exp[8] || &final_exp[7:0]) begin // Overflow
                z <= {sign, 8'hFF, 23'b0}; // Infinity
            end
            else if (final_exp == 0) begin // Underflow
                z <= {sign, 31'b0}; // Zero
            end
            else begin
                z <= {sign, final_exp[7:0], final_mant[22:0]};
            end
        end
    end

endmodule