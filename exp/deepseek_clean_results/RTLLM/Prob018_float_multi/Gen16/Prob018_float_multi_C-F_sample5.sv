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
    reg is_nan0, is_inf0, is_zero0, inf_zero0;

    // Pipeline stage 1: Partial products
    reg z_sign1;
    reg [7:0] z_exp1;
    reg [35:0] product_hi1, product_lo1;
    reg is_nan1, is_inf1, is_zero1, inf_zero1;

    // Pipeline stage 2: Product combination
    reg z_sign2;
    reg [7:0] z_exp2;
    reg [47:0] product2;
    reg is_nan2, is_inf2, is_zero2, inf_zero2;

    // Pipeline stage 3: Normalization and rounding
    reg z_sign3;
    reg [7:0] z_exp3;
    reg [22:0] z_mant3;
    reg guard3, sticky3;
    reg overflow3, underflow3;

    // Combinational special case detection
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    wire is_nan = a_nan | b_nan;
    wire is_inf = a_inf | b_inf;
    wire is_zero = a_zero | b_zero;
    wire inf_zero = (a_inf & b_zero) | (b_inf & a_zero);

    // Split multiplier signals
    wire [23:0] a_hi = {12'b0, a_mant0[23:12]};
    wire [23:0] a_lo = {12'b0, a_mant0[11:0]};
    wire [23:0] b_hi = {12'b0, b_mant0[23:12]};
    wire [23:0] b_lo = {12'b0, b_mant0[11:0]};

    // Pipeline stage 0: Input processing
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg0 <= 0;
            b_reg0 <= 0;
            is_nan0 <= 0;
            is_inf0 <= 0;
            is_zero0 <= 0;
            inf_zero0 <= 0;
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
            is_nan0 <= is_nan;
            is_inf0 <= is_inf;
            is_zero0 <= is_zero;
            inf_zero0 <= inf_zero;
        end
    end

    // Pipeline stage 1: Partial products
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_hi1 <= 0;
            product_lo1 <= 0;
            is_nan1 <= 0;
            is_inf1 <= 0;
            is_zero1 <= 0;
            inf_zero1 <= 0;
        end else begin
            // Only compute if not special case
            if (!(is_nan0 || is_inf0 || is_zero0 || inf_zero0)) begin
                product_hi1 <= a_hi * b_hi;
                product_lo1 <= (a_hi * b_lo) + (a_lo * b_hi) + (a_lo * b_lo);
            end
            
            // Pass through other signals
            z_sign1 <= a_sign0 ^ b_sign0;
            z_exp1 <= a_exp0 + b_exp0 - 8'd127;
            is_nan1 <= is_nan0;
            is_inf1 <= is_inf0;
            is_zero1 <= is_zero0;
            inf_zero1 <= inf_zero0;
        end
    end

    // Pipeline stage 2: Product combination
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product2 <= 0;
            is_nan2 <= 0;
            is_inf2 <= 0;
            is_zero2 <= 0;
            inf_zero2 <= 0;
        end else begin
            if (!(is_nan1 || is_inf1 || is_zero1 || inf_zero1)) begin
                product2 <= (product_hi1 << 24) + (product_lo1 << 12);
            end
            
            z_sign2 <= z_sign1;
            z_exp2 <= z_exp1;
            is_nan2 <= is_nan1;
            is_inf2 <= is_inf1;
            is_zero2 <= is_zero1;
            inf_zero2 <= inf_zero1;
        end
    end

    // Pipeline stage 3: Normalization and rounding
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            // Priority-encoded special cases
            if (is_nan2 || inf_zero2) begin
                z <= 32'h7FC00000; // NaN
            end else if (is_inf2) begin
                z <= {z_sign2, 8'hFF, 23'b0}; // Infinity
            end else if (is_zero2) begin
                z <= {z_sign2, 31'b0}; // Zero
            end else begin
                // Normal operation
                z_sign3 <= z_sign2;
                
                // Normalization
                if (product2[47]) begin
                    z_exp3 <= z_exp2 + 1;
                    z_mant3 <= product2[46:24];
                    guard3 <= product2[23];
                    sticky3 <= |product2[22:0];
                end else begin
                    z_exp3 <= z_exp2;
                    z_mant3 <= product2[45:23];
                    guard3 <= product2[22];
                    sticky3 <= |product2[21:0];
                end
                
                // Round to nearest even
                if (guard3 && (sticky3 || z_mant3[0])) begin
                    {z_exp3, z_mant3} <= {z_exp3, z_mant3} + 1;
                end
                
                // Overflow/underflow detection
                overflow3 <= (&z_exp3) || (z_exp3 >= 8'hFF);
                underflow3 <= (z_exp3 == 0) || (z_exp3[7] && (z_exp3 != 8'hFF));
                
                // Final output
                if (overflow3) begin
                    z <= {z_sign3, 8'hFF, 23'b0}; // Overflow -> Infinity
                end else if (underflow3) begin
                    z <= {z_sign3, 31'b0}; // Underflow -> Zero
                end else begin
                    z <= {z_sign3, z_exp3, z_mant3}; // Normal case
                end
            end
        end
    end

endmodule