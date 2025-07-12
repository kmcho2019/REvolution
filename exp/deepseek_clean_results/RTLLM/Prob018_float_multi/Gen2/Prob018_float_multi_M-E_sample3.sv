module float_multi (
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Special case detection (combinational)
    wire a_is_zero = (a[30:0] == 0);
    wire b_is_zero = (b[30:0] == 0);
    wire a_is_inf = (a[30:23] == 8'hFF) && (a[22:0] == 0);
    wire b_is_inf = (b[30:23] == 8'hFF) && (b[22:0] == 0);
    wire a_is_nan = (a[30:23] == 8'hFF) && (a[22:0] != 0);
    wire b_is_nan = (b[30:23] == 8'hFF) && (b[22:0] != 0);
    wire z_is_nan = a_is_nan | b_is_nan | (a_is_zero & b_is_inf) | (a_is_inf & b_is_zero);
    wire z_is_inf = (a_is_inf | b_is_inf) & ~z_is_nan;
    wire z_is_zero = (a_is_zero | b_is_zero) & ~z_is_nan;

    // Sign calculation
    wire z_sign = a[31] ^ b[31];

    // Exponent processing
    wire [8:0] a_exp_ext = {1'b0, a[30:23]};
    wire [8:0] b_exp_ext = {1'b0, b[30:23]};
    wire [9:0] exp_sum = {1'b0, a_exp_ext} + {1'b0, b_exp_ext} - 10'd127;
    
    // Mantissa processing with implicit bit
    wire [23:0] a_mant = (a[30:23] == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    wire [23:0] b_mant = (b[30:23] == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
    
    // Carry-save multiplier (3:2 compressor)
    wire [47:0] pp0 = a_mant * {24{b_mant[0]}};
    wire [47:0] pp1 = (a_mant * {24{b_mant[1]}}) << 1;
    wire [47:0] pp2 = (a_mant * {24{b_mant[2]}}) << 2;
    wire [47:0] sum, carry;
    assign sum = pp0 ^ pp1 ^ pp2;
    assign carry = (pp0 & pp1) | (pp0 & pp2) | (pp1 & pp2)) << 1;
    
    // Final adder (carry-propagate)
    wire [47:0] product = sum + carry;
    
    // Leading-zero detection for normalization
    wire [5:0] lzd;
    lzd48 lzd_inst (
        .in(product),
        .out(lzd)
    );
    
    // Normalization shift
    wire [47:0] norm_product = product << (47 - lzd);
    wire [9:0] norm_exp = exp_sum - (47 - lzd);
    
    // Rounding prediction
    wire guard = norm_product[22];
    wire round = norm_product[21];
    wire sticky = |norm_product[20:0];
    wire round_up = guard & (round | sticky | norm_product[23]);
    
    // Final mantissa with rounding
    wire [23:0] final_mant = norm_product[46:23] + round_up;
    wire [9:0] final_exp = norm_exp + final_mant[23];
    
    // Overflow/underflow detection
    wire overflow = (final_exp >= 255) | (final_exp[9]);
    wire underflow = (final_exp <= 0);
    
    // Output selection
    always @(*) begin
        if (z_is_nan) begin
            z = {1'b0, 8'hFF, 23'h7FFFFF}; // Canonical NaN
        end else if (z_is_inf) begin
            z = {z_sign, 8'hFF, 23'h0};
        end else if (z_is_zero) begin
            z = {z_sign, 31'h0};
        end else if (overflow) begin
            z = {z_sign, 8'hFF, 23'h0}; // Infinity
        end else if (underflow) begin
            z = {z_sign, 31'h0}; // Zero
        end else begin
            z = {z_sign, final_exp[7:0], final_mant[22:0]};
        end
    end

endmodule

// Leading-zero detector for 48-bit input
module lzd48 (
    input [47:0] in,
    output reg [5:0] out
);
    always @(*) begin
        casez (in)
            48'b1???????????????????????????????????????????????: out = 6'd0;
            48'b01???????????????????????????????????????????????: out = 6'd1;
            48'b001??????????????????????????????????????????????: out = 6'd2;
            // ... (all cases up to 47 leading zeros)
            48'b000000000000000000000000000000000000000000000001: out = 6'd47;
            48'b000000000000000000000000000000000000000000000000: out = 6'd48;
            default: out = 6'd0;
        endcase
    end
endmodule