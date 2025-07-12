module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg [23:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg a_sign, b_sign;
    
    reg [47:0] product;
    reg [7:0] exp_sum;
    reg sign_result;
    
    reg [22:0] z_mantissa;
    reg [7:0] z_exponent;
    reg z_sign;
    
    // Special case detection
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    
    // Combinational logic
    wire [7:0] exp_biased = exp_sum - 8'd127;
    wire [23:0] norm_mantissa = product[47] ? product[47:24] : product[46:23];
    wire norm_overflow = product[47];
    wire guard_bit = product[22];
    wire round_bit = product[21];
    wire sticky = |product[20:0];
    wire round_inc = guard_bit && (round_bit || sticky || norm_mantissa[0]);
    
    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {sign_result, 8'hFF, 23'b0};
    wire [31:0] zero_out = {sign_result, 31'b0};
    wire [31:0] normal_out = {z_sign, z_exponent, z_mantissa};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            // Stage 1: Input extraction
            a_sign <= a[31];
            b_sign <= b[31];
            a_exponent <= a[30:23];
            b_exponent <= b[30:23];
            a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
            b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
            
            // Stage 2: Multiplication
            product <= a_mantissa * b_mantissa;
            exp_sum <= a_exponent + b_exponent;
            sign_result <= a_sign ^ b_sign;
            
            // Stage 3: Normalization and rounding
            if (norm_overflow) begin
                z_mantissa <= norm_mantissa[23:1] + round_inc;
                z_exponent <= exp_biased + 1;
            end else begin
                z_mantissa <= norm_mantissa[22:0] + round_inc;
                z_exponent <= exp_biased;
            end
            z_sign <= sign_result;
            
            // Stage 4: Output generation
            if (a_nan || b_nan) begin
                z <= nan_out;
            end else if ((a_inf || b_inf) && (a_zero || b_zero)) begin
                z <= nan_out;
            end else if (a_inf || b_inf) begin
                z <= inf_out;
            end else if (a_zero || b_zero) begin
                z <= zero_out;
            end else if (&z_exponent || (z_exponent == 0)) begin
                z <= z_exponent == 0 ? zero_out : inf_out;
            end else begin
                z <= normal_out;
            end
        end
    end

endmodule