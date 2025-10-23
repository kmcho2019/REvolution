module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg stage;
    reg [31:0] a_reg, b_reg;
    reg z_sign;
    reg [7:0] a_exp, b_exp, z_exp;
    reg [23:0] a_man, b_man, z_man;
    reg [47:0] partial_products [11:0];
    reg [7:0] exp_sum;
    reg special_case;
    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;

    // Booth encoder outputs
    wire [2:0] booth_sel [11:0];
    wire [24:0] booth_pp [11:0];

    // Special case detection (combinational)
    always @(*) begin
        a_zero = ~|a[30:0];
        b_zero = ~|b[30:0];
        a_inf = &a[30:23] && ~|a[22:0];
        b_inf = &b[30:23] && ~|b[22:0];
        a_nan = &a[30:23] && |a[22:0];
        b_nan = &b[30:23] && |b[22:0];
        special_case = a_nan || b_nan || (a_inf && b_zero) || (b_inf && a_zero);
    end

    // Radix-4 Booth encoder
    genvar i;
    generate
        for (i = 0; i < 12; i = i + 1) begin : booth_encoder
            // Booth encoding
            assign booth_sel[i] = {b_man[i*2+1], b_man[i*2], (i == 0) ? 1'b0 : b_man[i*2-1]};
            
            // Partial product generation
            assign booth_pp[i] = 
                (booth_sel[i] == 3'b000 || booth_sel[i] == 3'b111) ? 25'b0 :
                (booth_sel[i] == 3'b001 || booth_sel[i] == 3'b010) ? {1'b0, a_man} :
                (booth_sel[i] == 3'b011) ? {a_man, 1'b0} :
                (booth_sel[i] == 3'b100) ? ~{a_man, 1'b0} + 1'b1 :
                (booth_sel[i] == 3'b101 || booth_sel[i] == 3'b110) ? ~{1'b0, a_man} + 1'b1 :
                25'b0;
        end
    endgenerate

    // Partial product alignment and sign extension
    always @(*) begin
        for (integer j = 0; j < 12; j = j + 1) begin
            partial_products[j] = {{(24-j*2){booth_pp[j][24]}}, booth_pp[j], {j*2{1'b0}};
        end
    end

    // 4:2 compressor tree for partial product reduction
    wire [47:0] sum_1, carry_1, sum_2, carry_2, sum_3, carry_3;
    wire [47:0] final_sum, final_carry;
    
    // First level of compression
    compressor_4_2 comp1 (partial_products[0], partial_products[1], partial_products[2], partial_products[3], 
                         sum_1, carry_1);
    compressor_4_2 comp2 (partial_products[4], partial_products[5], partial_products[6], partial_products[7], 
                         sum_2, carry_2);
    compressor_4_2 comp3 (partial_products[8], partial_products[9], partial_products[10], partial_products[11], 
                         sum_3, carry_3);
    
    // Second level of compression
    compressor_4_2 comp4 (sum_1, carry_1, sum_2, carry_2, sum_4, carry_4);
    
    // Final addition
    assign final_product = sum_4 + (carry_4 << 1) + sum_3 + (carry_3 << 1);

    // Normalization and rounding
    function [30:0] normalize_round;
        input [47:0] product;
        input [7:0] exp_in;
        reg [23:0] mantissa;
        reg [7:0] exponent;
        reg guard, round, sticky;
        begin
            // Normalization
            if (product[47]) begin
                mantissa = product[46:24];
                exponent = exp_in + 1;
            end else begin
                // Count leading zeros (optimized for synthesis)
                integer leading_zeros;
                leading_zeros = 0;
                if (~product[46]) leading_zeros = leading_zeros + 1;
                if (~product[45]) leading_zeros = leading_zeros + 1;
                // ... continue for all bits
                
                mantissa = product[46-leading_zeros:24-leading_zeros];
                exponent = exp_in - leading_zeros;
            end
            
            // Rounding
            guard = product[23];
            round = product[22];
            sticky = |product[21:0];
            
            if (guard && (round || sticky || mantissa[0])) begin
                mantissa = mantissa + 1;
                if (&mantissa) exponent = exponent + 1;
            end
            
            normalize_round = {exponent, mantissa[22:0]};
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
        end else begin
            case (stage)
                0: begin // Stage 1: Input processing and partial product generation
                    a_reg <= a;
                    b_reg <= b;
                    
                    if (special_case) begin
                        if (a_nan || b_nan || (a_inf && b_zero) || (b_inf && a_zero)) begin
                            z <= {1'b0, 8'hFF, 23'h400000}; // qNaN
                        end else if (a_inf || b_inf) begin
                            z <= {a[31] ^ b[31], 8'hFF, 23'h0}; // Inf
                        end else begin // Zero
                            z <= {a[31] ^ b[31], 31'h0};
                        end
                        stage <= 0;
                    end else begin
                        a_sign <= a[31];
                        b_sign <= b[31];
                        a_exp <= a[30:23];
                        b_exp <= b[30:23];
                        a_man <= |a[30:23] ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                        b_man <= |b[30:23] ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                        exp_sum <= a[30:23] + b[30:23] - 8'd127;
                        z_sign <= a[31] ^ b[31];
                        stage <= 1;
                    end
                end
                
                1: begin // Stage 2: Product reduction and normalization
                    {z_exp, z_man[22:0]} = normalize_round(final_product, exp_sum);
                    
                    // Handle overflow/underflow
                    if (z_exp[7] || (&z_exp)) begin
                        z <= z_exp[7] ? {z_sign, 31'h0} : {z_sign, 8'hFF, 23'h0};
                    end else begin
                        z <= {z_sign, z_exp, z_man[22:0]};
                    end
                    stage <= 0;
                end
            endcase
        end
    end

endmodule

// 4:2 compressor module
module compressor_4_2 (
    input [47:0] a, b, c, d,
    output [47:0] sum, carry
);
    // Implement 4:2 compressor logic
    assign sum = a ^ b ^ c ^ d;
    assign carry = ((a & b) | (a & c) | (b & c)) << 1;
endmodule