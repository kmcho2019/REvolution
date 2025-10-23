module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // One-hot state encoding
    localparam STAGE0 = 4'b0001;
    localparam STAGE1 = 4'b0010;
    localparam STAGE2 = 4'b0100;
    localparam STAGE3 = 4'b1000;
    
    reg [3:0] state;
    
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

    // Gated special case detection
    wire a_zero = (state == STAGE0) && (a[30:0] == 0);
    wire b_zero = (state == STAGE0) && (b[30:0] == 0);
    wire a_inf = (state == STAGE0) && (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (state == STAGE0) && (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (state == STAGE0) && (&a[30:23]) && (|a[22:0]);
    wire b_nan = (state == STAGE0) && (&b[30:23]) && (|b[22:0]);
    wire special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;

    // Split multiplier signals with carry-save optimization
    wire [11:0] a_hi = a_mant0[23:12];
    wire [11:0] a_lo = a_mant0[11:0];
    wire [11:0] b_hi = b_mant0[23:12];
    wire [11:0] b_lo = b_mant0[11:0];
    
    // Carry-save intermediate products
    wire [23:0] hi_hi = a_hi * b_hi;
    wire [23:0] hi_lo = a_hi * b_lo;
    wire [23:0] lo_hi = a_lo * b_hi;
    wire [23:0] lo_lo = a_lo * b_lo;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= STAGE0;
            z <= 0;
            special_case0 <= 0;
            special_case1 <= 0;
            special_case2 <= 0;
            special_case3 <= 0;
        end else begin
            case (state)
                STAGE0: begin  // Input processing
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
                    
                    state <= STAGE1;
                end
                
                STAGE1: begin  // Partial products
                    if (!special_case0) begin
                        product_hi1 <= hi_hi;
                        product_mid1 <= hi_lo + lo_hi;
                        product_lo1 <= lo_lo;
                    end
                    
                    // Pass through other signals
                    a_sign1 <= a_sign0;
                    b_sign1 <= b_sign0;
                    z_exp1 <= {1'b0, a_exp0} + {1'b0, b_exp0} - 9'd127;
                    special_case1 <= special_case0;
                    
                    state <= STAGE2;
                end
                
                STAGE2: begin  // Product combination
                    if (!special_case1) begin
                        product2 <= (product_hi1 << 24) + (product_mid1 << 12) + product_lo1;
                    end
                    
                    z_sign2 <= a_sign1 ^ b_sign1;
                    z_exp2 <= z_exp1;
                    special_case2 <= special_case1;
                    
                    state <= STAGE3;
                end
                
                STAGE3: begin  // Normalization and rounding
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
                    
                    state <= STAGE0;
                end
            endcase
        end
    end

endmodule