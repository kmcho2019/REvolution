module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage 0: Input processing
    reg [31:0] a_reg0, b_reg0;
    reg a_sign0, b_sign0;
    reg [7:0] a_exp0, b_exp0;
    reg [23:0] a_mant0, b_mant0;
    reg special_case0;
    reg a_nan0, b_nan0, a_inf0, b_inf0, a_zero0, b_zero0;

    // Pipeline stage 1: Partial products
    reg a_sign1, b_sign1;
    reg [8:0] z_exp1;
    reg [35:0] product_hi1, product_mid1, product_lo1;
    reg special_case1;

    // Pipeline stage 2: Product combination
    reg z_sign2;
    reg [8:0] z_exp2;
    reg [47:0] product2;
    reg special_case2;

    // Pipeline stage 3: Normalization and rounding
    reg z_sign3;
    reg [7:0] z_exp3;
    reg [23:0] z_mant3;
    reg guard3, sticky3;
    reg special_case3;

    // Combinational special case detection (gated with pipeline stage)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    wire special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;

    // Split multiplier signals
    wire [23:0] a_hi = a_mant0[23:12];
    wire [23:0] a_lo = {12'b0, a_mant0[11:0]};
    wire [23:0] b_hi = b_mant0[23:12];
    wire [23:0] b_lo = {12'b0, b_mant0[11:0]};

    // Pipeline stage 0: Input processing
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg0 <= 0;
            b_reg0 <= 0;
            special_case0 <= 0;
        end else begin
            a_reg0 <= a;
            b_reg0 <= b;
            a_sign0 <= a[31];
            b_sign0 <= b[31];
            a_exp0 <= a[30:23];
            b_exp0 <= b[30:23];
            
            // Handle subnormal numbers
            a_mant0 <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
            b_mant0 <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
            
            // Special case tracking
            special_case0 <= special_case;
            a_nan0 <= a_nan;
            b_nan0 <= b_nan;
            a_inf0 <= a_inf;
            b_inf0 <= b_inf;
            a_zero0 <= a_zero;
            b_zero0 <= b_zero;
        end
    end

    // Pipeline stage 1: Partial products
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_hi1 <= 0;
            product_mid1 <= 0;
            product_lo1 <= 0;
            special_case1 <= 0;
        end else begin
            // Only compute if not special case
            if (!special_case0) begin
                product_hi1 <= a_hi * b_hi;
                product_mid1 <= (a_hi * b_lo) + (a_lo * b_hi);
                product_lo1 <= a_lo * b_lo;
            end
            
            // Pass through other signals
            a_sign1 <= a_sign0;
            b_sign1 <= b_sign0;
            z_exp1 <= {1'b0, a_exp0} + {1'b0, b_exp0} - 9'd127;
            special_case1 <= special_case0;
        end
    end

    // Pipeline stage 2: Product combination
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product2 <= 0;
            special_case2 <= 0;
        end else begin
            if (!special_case1) begin
                product2 <= (product_hi1 << 24) + (product_mid1 << 12) + product_lo1;
            end
            
            z_sign2 <= a_sign1 ^ b_sign1;
            z_exp2 <= z_exp1;
            special_case2 <= special_case1;
        end
    end

    // Pipeline stage 3: Normalization and rounding
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            if (special_case2) begin
                // Handle special cases
                if (a_nan0 || b_nan0) begin
                    z <= 32'h7FC00000;  // NaN
                end else if (a_inf0 || b_inf0) begin
                    z <= (a_zero0 || b_zero0) ? 32'h7FC00000 : {z_sign2, 8'hFF, 23'b0};
                end else begin  // a_zero0 || b_zero0
                    z <= {z_sign2, 31'b0};
                end
            end else begin
                // Normal operation
                z_sign3 <= z_sign2;
                
                // Normalization
                if (product2[47]) begin
                    z_exp3 <= z_exp2[7:0] + 1;
                    z_mant3 <= product2[47:24];
                    guard3 <= product2[23];
                    sticky3 <= |product2[22:0];
                end else begin
                    z_exp3 <= z_exp2[7:0];
                    z_mant3 <= product2[46:23];
                    guard3 <= product2[22];
                    sticky3 <= |product2[21:0];
                end
                
                // Round to nearest even
                if (guard3 && (sticky3 || z_mant3[0])) begin
                    {z_exp3, z_mant3} <= {z_exp3, z_mant3} + 1;
                end
                
                // Final output
                if (z_exp3 == 8'hFF) begin
                    z <= {z_sign3, 8'hFF, 23'b0};  // Overflow
                end else if (z_exp3 == 0) begin
                    z <= {z_sign3, 31'b0};  // Underflow
                end else begin
                    z <= {z_sign3, z_exp3, z_mant3[22:0]};
                end
            end
        end
    end

endmodule