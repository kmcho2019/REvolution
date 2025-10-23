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
    wire special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;

    // Pipeline stage 0 registers
    reg [31:0] a_reg0, b_reg0;
    reg special_case0;
    reg [1:0] path_sel0; // 00=normal, 01=a_sub, 10=b_sub, 11=both_sub
    reg a_sign0, b_sign0;
    reg [7:0] a_exp0, b_exp0;
    reg [23:0] a_mant0, b_mant0;

    // Pipeline stage 1 registers
    reg special_case1;
    reg z_sign1;
    reg [8:0] z_exp1;
    reg [47:0] product1;
    reg [1:0] path_sel1;
    reg [4:0] leading_zeros1;

    // Pipeline stage 2 registers
    reg special_case2;
    reg z_sign2;
    reg [8:0] z_exp2;
    reg [23:0] z_mant2;
    reg [2:0] round_bits2;

    // Input processing stage
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg0 <= 0;
            b_reg0 <= 0;
            special_case0 <= 0;
            path_sel0 <= 0;
            a_sign0 <= 0;
            b_sign0 <= 0;
            a_exp0 <= 0;
            b_exp0 <= 0;
            a_mant0 <= 0;
            b_mant0 <= 0;
        end else begin
            a_reg0 <= a;
            b_reg0 <= b;
            special_case0 <= special_case;
            a_sign0 <= a[31];
            b_sign0 <= b[31];
            
            // Handle subnormal numbers
            path_sel0[0] <= (a[30:23] == 0);
            path_sel0[1] <= (b[30:23] == 0);
            
            a_exp0 <= a[30:23];
            b_exp0 <= b[30:23];
            
            // Normalize subnormal mantissas
            a_mant0 <= (a[30:23] == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            b_mant0 <= (b[30:23] == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
        end
    end

    // Multiplication and exponent calculation stage
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            special_case1 <= 0;
            z_sign1 <= 0;
            z_exp1 <= 0;
            product1 <= 0;
            path_sel1 <= 0;
            leading_zeros1 <= 0;
        end else begin
            special_case1 <= special_case0;
            z_sign1 <= a_sign0 ^ b_sign0;
            path_sel1 <= path_sel0;
            
            // Modified Booth multiplier implementation
            product1 <= booth_mult(a_mant0, b_mant0);
            
            // Exponent calculation with subnormal adjustment
            case (path_sel0)
                2'b00: z_exp1 <= {1'b0, a_exp0} + {1'b0, b_exp0} - 9'd127;
                2'b01: z_exp1 <= {1'b0, a_exp0} + {1'b0, b_exp0} - 9'd126;
                2'b10: z_exp1 <= {1'b0, a_exp0} + {1'b0, b_exp0} - 9'd126;
                2'b11: z_exp1 <= {1'b0, a_exp0} + {1'b0, b_exp0} - 9'd125;
            endcase
            
            // Leading zero count for subnormal results
            leading_zeros1 <= count_leading_zeros(product1[47:24]);
        end
    end

    // Normalization and rounding stage
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            special_case2 <= 0;
            z_sign2 <= 0;
            z_exp2 <= 0;
            z_mant2 <= 0;
            round_bits2 <= 0;
        end else begin
            special_case2 <= special_case1;
            z_sign2 <= z_sign1;
            
            // Normalization
            if (product1[47]) begin
                z_exp2 <= z_exp1 + 1;
                z_mant2 <= product1[47:25];
                round_bits2 <= {product1[24], product1[23], |product1[22:0]};
            end else begin
                // Handle subnormal results
                if (path_sel1 != 2'b00 && leading_zeros1 > 0) begin
                    z_exp2 <= z_exp1 - leading_zeros1;
                    z_mant2 <= product1[46:24] << leading_zeros1;
                    round_bits2 <= {product1[23:22], |product1[21:0]};
                end else begin
                    z_exp2 <= z_exp1;
                    z_mant2 <= product1[46:24];
                    round_bits2 <= {product1[23:22], |product1[21:0]};
                end
            end
        end
    end

    // Output stage
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            if (special_case2) begin
                // Handle special cases
                if (a_nan || b_nan) begin
                    z <= 32'h7FC00000; // NaN
                end else if (a_inf || b_inf) begin
                    z <= (a_zero || b_zero) ? 32'h7FC00000 : {z_sign2, 8'hFF, 23'b0};
                end else begin // Zero
                    z <= {z_sign2, 31'b0};
                end
            end else if (z_exp2[8] || (z_exp2[7:0] == 8'hFF)) begin
                z <= {z_sign2, 8'hFF, 23'b0}; // Overflow
            end else if (z_exp2[7:0] == 0) begin
                z <= {z_sign2, 31'b0}; // Underflow
            end else begin
                // Apply rounding (thermometer coded)
                case (round_bits2)
                    3'b100, 3'b101, 3'b110, 3'b111: z <= {z_sign2, z_exp2[7:0], z_mant2[22:0]} + 1;
                    default: z <= {z_sign2, z_exp2[7:0], z_mant2[22:0]};
                endcase
            end
        end
    end

    // Modified Booth multiplier function
    function [47:0] booth_mult;
        input [23:0] a, b;
        reg [47:0] pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7, pp8, pp9, pp10, pp11;
        reg [47:0] sum0, sum1, sum2, sum3, sum4, sum5;
        begin
            // Partial product generation
            pp0 = b[0] ? {24'b0, a} : 48'b0;
            pp1 = b[1] ? {23'b0, a, 1'b0} : 48'b0;
            pp2 = b[2] ? {22'b0, a, 2'b0} : 48'b0;
            pp3 = b[3] ? {21'b0, a, 3'b0} : 48'b0;
            pp4 = b[4] ? {20'b0, a, 4'b0} : 48'b0;
            pp5 = b[5] ? {19'b0, a, 5'b0} : 48'b0;
            pp6 = b[6] ? {18'b0, a, 6'b0} : 48'b0;
            pp7 = b[7] ? {17'b0, a, 7'b0} : 48'b0;
            pp8 = b[8] ? {16'b0, a, 8'b0} : 48'b0;
            pp9 = b[9] ? {15'b0, a, 9'b0} : 48'b0;
            pp10 = b[10] ? {14'b0, a, 10'b0} : 48'b0;
            pp11 = b[11] ? {13'b0, a, 11'b0} : 48'b0;
            
            // Carry-save adder tree
            sum0 = pp0 + pp1 + pp2;
            sum1 = pp3 + pp4 + pp5;
            sum2 = pp6 + pp7 + pp8;
            sum3 = pp9 + pp10 + pp11;
            sum4 = sum0 + sum1;
            sum5 = sum2 + sum3;
            booth_mult = sum4 + sum5;
        end
    endfunction

    // Leading zero counter function
    function [4:0] count_leading_zeros;
        input [23:0] val;
        begin
            count_leading_zeros = 
                val[23] ? 0 :
                val[22] ? 1 :
                val[21] ? 2 :
                val[20] ? 3 :
                val[19] ? 4 :
                val[18] ? 5 :
                val[17] ? 6 :
                val[16] ? 7 :
                val[15] ? 8 :
                val[14] ? 9 :
                val[13] ? 10 :
                val[12] ? 11 :
                val[11] ? 12 :
                val[10] ? 13 :
                val[9] ? 14 :
                val[8] ? 15 :
                val[7] ? 16 :
                val[6] ? 17 :
                val[5] ? 18 :
                val[4] ? 19 :
                val[3] ? 20 :
                val[2] ? 21 :
                val[1] ? 22 :
                val[0] ? 23 : 24;
        end
    endfunction

endmodule