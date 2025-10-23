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
    reg [23:0] a_mant0, b_mant0;
    reg a_zero0, b_zero0, a_inf0, b_inf0, a_nan0, b_nan0;

    // Pipeline stage 1 registers (multiplication)
    reg a_sign1, b_sign1;
    reg [8:0] z_exp1;
    reg [47:0] product1;
    reg special_case1;

    // Pipeline stage 2 registers (normalization)
    reg z_sign2;
    reg [8:0] z_exp2;
    reg [23:0] z_mant2;
    reg guard2, sticky2;
    reg special_case2;

    // Pipeline stage 3 registers (rounding and output)
    reg z_sign3;
    reg [8:0] z_exp3;
    reg [23:0] z_mant3;
    reg special_case3;

    // Combinational special case detection
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    wire special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;

    // Pipeline stage 0: Input processing
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
        end else begin
            a_reg0 <= a;
            b_reg0 <= b;
            a_sign0 <= a[31];
            b_sign0 <= b[31];
            a_exp0 <= a[30:23];
            b_exp0 <= b[30:23];
            a_mant0 <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
            b_mant0 <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
            a_zero0 <= a_zero;
            b_zero0 <= b_zero;
            a_inf0 <= a_inf;
            b_inf0 <= b_inf;
            a_nan0 <= a_nan;
            b_nan0 <= b_nan;
        end
    end

    // Pipeline stage 1: Multiplication and exponent calculation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_sign1 <= 0;
            b_sign1 <= 0;
            z_exp1 <= 0;
            product1 <= 0;
            special_case1 <= 0;
        end else begin
            a_sign1 <= a_sign0;
            b_sign1 <= b_sign0;
            z_exp1 <= {1'b0, a_exp0} + {1'b0, b_exp0} - 9'd127;
            product1 <= a_mant0 * b_mant0;
            special_case1 <= special_case;
        end
    end

    // Pipeline stage 2: Normalization and rounding bits
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z_sign2 <= 0;
            z_exp2 <= 0;
            z_mant2 <= 0;
            guard2 <= 0;
            sticky2 <= 0;
            special_case2 <= 0;
        end else begin
            z_sign2 <= a_sign1 ^ b_sign1;
            special_case2 <= special_case1;
            
            if (product1[47]) begin
                z_exp2 <= z_exp1 + 1;
                z_mant2 <= product1[47:24];
                guard2 <= product1[23];
                sticky2 <= |product1[22:0];
            end else begin
                z_exp2 <= z_exp1;
                z_mant2 <= product1[46:23];
                guard2 <= product1[22];
                sticky2 <= |product1[21:0];
            end
        end
    end

    // Pipeline stage 3: Rounding and output generation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z_sign3 <= 0;
            z_exp3 <= 0;
            z_mant3 <= 0;
            special_case3 <= 0;
            z <= 0;
        end else begin
            z_sign3 <= z_sign2;
            special_case3 <= special_case2;
            
            // Apply rounding if needed
            if (guard2 && (sticky2 || z_mant2[0])) begin
                {z_exp3, z_mant3} <= {z_exp2, z_mant2} + 1;
            end else begin
                z_exp3 <= z_exp2;
                z_mant3 <= z_mant2;
            end
            
            // Final output generation
            if (special_case3) begin
                if (a_nan0 || b_nan0) begin
                    z <= 32'h7FC00000;  // NaN
                end else if (a_inf0 || b_inf0) begin
                    z <= (a_zero0 || b_zero0) ? 32'h7FC00000 : {z_sign3, 8'hFF, 23'b0};
                end else begin  // a_zero0 || b_zero0
                    z <= {z_sign3, 31'b0};
                end
            end else if (z_exp3[8] || (z_exp3[7:0] == 8'hFF)) begin
                z <= {z_sign3, 8'hFF, 23'b0};  // Overflow
            end else if (~|z_exp3[7:0]) begin
                z <= {z_sign3, 31'b0};  // Underflow
            end else begin
                z <= {z_sign3, z_exp3[7:0], z_mant3[22:0]};
            end
        end
    end

endmodule