module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Input registers with operand isolation
    reg [31:0] a_reg, b_reg;
    wire load_inputs = !rst && (a != a_reg || b != b_reg);
    
    // Special case detection
    wire a_nan = &a[30:23] && |a[22:0];
    wire b_nan = &b[30:23] && |b[22:0];
    wire a_inf = &a[30:23] && ~|a[22:0];
    wire b_inf = &b[30:23] && ~|b[22:0];
    wire a_zero = ~|a[30:0];
    wire b_zero = ~|b[30:0];
    
    wire is_nan = a_nan || b_nan || (a_inf && b_zero) || (b_inf && a_zero);
    wire is_inf = (a_inf || b_inf) && !is_nan;
    wire is_zero = (a_zero || b_zero) && !is_nan && !is_inf;
    
    // Sign calculation
    wire result_sign = a[31] ^ b[31];
    
    // Exponent calculation with early overflow/underflow detection
    wire [8:0] exp_sum = {1'b0, a[30:23]} + {1'b0, b[30:23]} - 9'd127;
    wire exp_ovf = exp_sum[8] || (&exp_sum[7:0]);
    wire exp_udf = (exp_sum < 9'd1);
    
    // Mantissa preparation with implicit leading bit
    wire [23:0] a_man = |a[30:23] ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
    wire [23:0] b_man = |b[30:23] ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
    
    // Booth-encoded multiplication (Radix-4)
    wire [47:0] booth_partials [11:0];
    generate
        genvar i;
        for (i = 0; i < 12; i = i + 1) begin : booth_gen
            wire [2:0] booth_bits = (i == 0) ? {b_man[1:0], 1'b0} : 
                                   b_man[2*i+1:2*i-1];
            
            always @(*) begin
                case (booth_bits)
                    3'b000, 3'b111: booth_partials[i] = 48'b0;
                    3'b001, 3'b010: booth_partials[i] = {24'b0, a_man} << (2*i);
                    3'b011:         booth_partials[i] = {23'b0, a_man, 1'b0} << (2*i);
                    3'b100:         booth_partials[i] = ~{23'b0, a_man, 1'b0} << (2*i) + 1;
                    3'b101, 3'b110: booth_partials[i] = ~{24'b0, a_man} << (2*i) + 1;
                endcase
            end
        end
    endgenerate
    
    // Wallace tree reduction
    wire [47:0] product = booth_partials[0] + booth_partials[1] + booth_partials[2] + 
                         booth_partials[3] + booth_partials[4] + booth_partials[5] +
                         booth_partials[6] + booth_partials[7] + booth_partials[8] +
                         booth_partials[9] + booth_partials[10] + booth_partials[11];
    
    // Leading-one detection and normalization
    wire [4:0] lzd;
    lzd48 lzd_inst(.in(product), .pos(lzd));
    
    wire [47:0] norm_product = product << lzd;
    wire [7:0] final_exp = exp_sum - lzd + 1;
    
    // Rounding
    wire round_bit = norm_product[22];
    wire sticky_bit = |norm_product[21:0];
    wire round_up = round_bit & (norm_product[23] | sticky_bit);
    wire [22:0] rounded_mantissa = norm_product[46:24] + round_up;
    
    // Final result assembly
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'b0;
            a_reg <= 32'b0;
            b_reg <= 32'b0;
        end else if (load_inputs) begin
            a_reg <= a;
            b_reg <= b;
            
            if (is_nan) begin
                z <= {result_sign, 8'hFF, 1'b1, 22'b0};
            end else if (is_inf || exp_ovf) begin
                z <= {result_sign, 8'hFF, 23'b0};
            end else if (is_zero || exp_udf) begin
                z <= {result_sign, 31'b0};
            end else begin
                z <= {result_sign, final_exp, rounded_mantissa[22:0]};
            end
        end
    end

endmodule

module lzd48(
    input [47:0] in,
    output reg [4:0] pos
);
    always @(*) begin
        casez (in)
            48'b1???????????????????????????????????????????????: pos = 5'd0;
            48'b01??????????????????????????????????????????????: pos = 5'd1;
            48'b001?????????????????????????????????????????????: pos = 5'd2;
            // ... (all cases up to 47 leading zeros)
            48'b000000000000000000000000000000000000000000000001: pos = 5'd47;
            48'b000000000000000000000000000000000000000000000000: pos = 5'd48;
        endcase
    end
endmodule