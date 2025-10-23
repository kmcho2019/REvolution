module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage 0 registers (input processing)
    reg [31:0] a_reg0, b_reg0;
    reg a_sign0, b_sign0;
    reg [7:0] a_exp0, b_exp0;
    reg [22:0] a_mant0, b_mant0;
    reg a_zero0, b_zero0, a_inf0, b_inf0, a_nan0, b_nan0;
    reg special_case0;

    // Pipeline stage 1 registers (partial multiplication)
    reg a_sign1, b_sign1;
    reg [7:0] z_exp1;
    reg [23:0] a_mant1, b_mant1;
    reg [23:0] product_hi1, product_lo1;
    reg special_case1;

    // Pipeline stage 2 registers (product combination)
    reg z_sign2;
    reg [7:0] z_exp2;
    reg [47:0] product2;
    reg special_case2;

    // Pipeline stage 3 registers (normalization)
    reg z_sign3;
    reg [7:0] z_exp3;
    reg [23:0] z_mant3;
    reg guard3, sticky3;
    reg special_case3;

    // Pipeline stage 4 registers (rounding and output)
    reg z_sign4;
    reg [7:0] z_exp4;
    reg [22:0] z_mant4;
    reg special_case4;

    // Combinational special case detection
    wire a_zero_w = (a[30:0] == 0);
    wire b_zero_w = (b[30:0] == 0);
    wire a_inf_w = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf_w = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan_w = (&a[30:23]) && (|a[22:0]);
    wire b_nan_w = (&b[30:23]) && (|b[22:0]);

    // Pipeline stage 0: Input processing and early special case detection
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg0 <= 0;
            b_reg0 <= 0;
            a_sign0 <= 0;
            b_sign0 <= 0;
            a_exp0 <= 0;
            b_exp0 <= 0;
            a_mant0 <= 0;
            b_mant0 <= 0;
            a_zero0 <= 0;
            b_zero0 <= 0;
            a_inf0 <= 0;
            b_inf0 <= 0;
            a_nan0 <= 0;
            b_nan0 <= 0;
            special_case0 <= 0;
        end else begin
            a_reg0 <= a;
            b_reg0 <= b;
            a_sign0 <= a[31];
            b_sign0 <= b[31];
            a_exp0 <= a[30:23];
            b_exp0 <= b[30:23];
            a_mant0 <= a[22:0];
            b_mant0 <= b[22:0];
            a_zero0 <= a_zero_w;
            b_zero0 <= b_zero_w;
            a_inf0 <= a_inf_w;
            b_inf0 <= b_inf_w;
            a_nan0 <= a_nan_w;
            b_nan0 <= b_nan_w;
            special_case0 <= a_nan_w | b_nan_w | a_inf_w | b_inf_w | a_zero_w | b_zero_w;
        end
    end

    // Pipeline stage 1: Partial multiplication and exponent calculation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_sign1 <= 0;
            b_sign1 <= 0;
            z_exp1 <= 0;
            a_mant1 <= 0;
            b_mant1 <= 0;
            product_hi1 <= 0;
            product_lo1 <= 0;
            special_case1 <= 0;
        end else begin
            a_sign1 <= a_sign0;
            b_sign1 <= b_sign0;
            z_exp1 <= a_exp0 + b_exp0 - 8'd127;  // Pre-computed bias
            special_case1 <= special_case0;
            
            // Only compute multiplication if not special case
            if (!special_case0 && (|a_exp0) && (|b_exp0)) begin
                a_mant1 <= {1'b1, a_mant0};
                b_mant1 <= {1'b1, b_mant0};
                // Break multiplication into two parts
                product_hi1 <= {1'b0, a_mant0} * b_mant0[22:11];
                product_lo1 <= {1'b0, a_mant0} * b_mant0[11:0];
            end else begin
                a_mant1 <= 0;
                b_mant1 <= 0;
                product_hi1 <= 0;
                product_lo1 <= 0;
            end
        end
    end

    // Pipeline stage 2: Combine partial products
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z_sign2 <= 0;
            z_exp2 <= 0;
            product2 <= 0;
            special_case2 <= 0;
        end else begin
            z_sign2 <= a_sign1 ^ b_sign1;
            z_exp2 <= z_exp1;
            special_case2 <= special_case1;
            
            if (!special_case1) begin
                // Combine partial products with proper shifting
                product2 <= (product_hi1 << 12) + product_lo1;
            end else begin
                product2 <= 0;
            end
        end
    end

    // Pipeline stage 3: Normalization and rounding bits
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z_sign3 <= 0;
            z_exp3 <= 0;
            z_mant3 <= 0;
            guard3 <= 0;
            sticky3 <= 0;
            special_case3 <= 0;
        end else begin
            z_sign3 <= z_sign2;
            special_case3 <= special_case2;
            
            if (special_case2) begin
                z_exp3 <= 0;
                z_mant3 <= 0;
                guard3 <= 0;
                sticky3 <= 0;
            end else if (product2[47]) begin
                z_exp3 <= z_exp2 + 1;
                z_mant3 <= product2[47:24];
                guard3 <= product2[23];
                sticky3 <= |product2[22:0];
            end else begin
                z_exp3 <= z_exp2;
                z_mant3 <= product2[46:23];
                guard3 <= product2[22];
                sticky3 <= |product2[21:0];
            end
        end
    end

    // Pipeline stage 4: Rounding and output generation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z_sign4 <= 0;
            z_exp4 <= 0;
            z_mant4 <= 0;
            special_case4 <= 0;
            z <= 0;
        end else begin
            z_sign4 <= z_sign3;
            special_case4 <= special_case3;
            
            // Apply rounding if needed
            if (!special_case3 && guard3 && (sticky3 || z_mant3[0])) begin
                {z_exp4, z_mant4} <= {z_exp3, z_mant3[22:0]} + 1;
            end else begin
                z_exp4 <= z_exp3;
                z_mant4 <= z_mant3[22:0];
            end
            
            // Final output generation
            if (special_case4) begin
                if (a_nan0 || b_nan0) begin
                    z <= 32'h7FC00000;  // NaN
                end else if (a_inf0 || b_inf0) begin
                    z <= (a_zero0 || b_zero0) ? 32'h7FC00000 : {z_sign4, 8'hFF, 23'b0};
                end else begin  // a_zero0 || b_zero0
                    z <= {z_sign4, 31'b0};
                end
            end else if (z_exp4 == 8'hFF) begin
                z <= {z_sign4, 8'hFF, 23'b0};  // Overflow
            end else if (z_exp4 == 0) begin
                z <= {z_sign4, 31'b0};  // Underflow
            end else begin
                z <= {z_sign4, z_exp4, z_mant4};
            end
        end
    end

endmodule