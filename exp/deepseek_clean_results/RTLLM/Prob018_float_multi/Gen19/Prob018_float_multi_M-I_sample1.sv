module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Special case detection (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    wire special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;

    // Pipeline stage 0 registers (input processing)
    reg a_sign0, b_sign0;
    reg [7:0] a_exp0, b_exp0;
    reg [23:0] a_mant0, b_mant0;
    reg special_case0;
    reg [1:0] case_type0; // 00:normal, 01:zero, 10:inf, 11:nan

    // Pipeline stage 1 registers (multiplication)
    reg z_sign1;
    reg [7:0] z_exp1;
    reg [23:0] z_mant1_msb, z_mant1_lsb;
    reg guard1, sticky1;
    reg special_case1;
    reg [1:0] case_type1;

    // Pipeline stage 2 registers (rounding and output)
    reg z_sign2;
    reg [7:0] z_exp2;
    reg [22:0] z_mant2;
    reg special_case2;
    reg [1:0] case_type2;

    // Clock gating enable
    wire clk_en = ~rst & ~special_case;

    // Pipeline stage 0: Input processing
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_sign0 <= 0;
            b_sign0 <= 0;
            a_exp0 <= 0;
            b_exp0 <= 0;
            a_mant0 <= 0;
            b_mant0 <= 0;
            special_case0 <= 0;
            case_type0 <= 0;
        end else if (clk_en) begin
            a_sign0 <= a[31];
            b_sign0 <= b[31];
            a_exp0 <= a[30:23];
            b_exp0 <= b[30:23];
            a_mant0 <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
            b_mant0 <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
            
            special_case0 <= special_case;
            case_type0 <= a_nan || b_nan ? 2'b11 : 
                         a_inf || b_inf ? 2'b10 : 
                         a_zero || b_zero ? 2'b01 : 2'b00;
        end
    end

    // Karatsuba multiplication (a*b = (a_hi*b_hi)<<24 + ((a_hi+a_lo)*(b_hi+b_lo)-a_hi*b_hi-a_lo*b_lo)<<12 + a_lo*b_lo)
    wire [23:0] a_hi = a_mant0[23:12];
    wire [11:0] a_lo = a_mant0[11:0];
    wire [23:0] b_hi = b_mant0[23:12];
    wire [11:0] b_lo = b_mant0[11:0];
    
    wire [23:0] a_sum = a_hi + a_lo;
    wire [23:0] b_sum = b_hi + b_lo;
    
    wire [35:0] prod_hi = a_hi * b_hi;
    wire [35:0] prod_mid = a_sum * b_sum;
    wire [23:0] prod_lo = a_lo * b_lo;
    
    wire [47:0] product = {prod_hi, 12'b0} + 
                         ({prod_mid - prod_hi - {24'b0, prod_lo}, 12'b0}) + 
                         {36'b0, prod_lo};

    // Pipeline stage 1: Multiplication and normalization
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z_sign1 <= 0;
            z_exp1 <= 0;
            z_mant1_msb <= 0;
            z_mant1_lsb <= 0;
            guard1 <= 0;
            sticky1 <= 0;
            special_case1 <= 0;
            case_type1 <= 0;
        end else if (clk_en) begin
            z_sign1 <= a_sign0 ^ b_sign0;
            z_exp1 <= a_exp0 + b_exp0 - 126; // -127 +1 for potential normalization
            
            // Normalization decision and mantissa selection
            if (product[47]) begin
                z_mant1_msb <= product[47:24];
                z_mant1_lsb <= product[23:0];
                z_exp1 <= z_exp1 + 1;
            end else begin
                z_mant1_msb <= product[46:23];
                z_mant1_lsb <= product[22:0];
            end
            
            guard1 <= product[23];
            sticky1 <= |product[22:0];
            special_case1 <= special_case0;
            case_type1 <= case_type0;
        end
    end

    // Pipeline stage 2: Rounding and output generation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z_sign2 <= 0;
            z_exp2 <= 0;
            z_mant2 <= 0;
            special_case2 <= 0;
            case_type2 <= 0;
            z <= 0;
        end else begin
            z_sign2 <= z_sign1;
            special_case2 <= special_case1;
            case_type2 <= case_type1;
            
            // Handle special cases first
            if (special_case1) begin
                case (case_type1)
                    2'b11: z <= 32'h7FC00000; // NaN
                    2'b10: z <= (case_type0 == 2'b01) ? 32'h7FC00000 : {z_sign1, 8'hFF, 23'b0}; // Inf
                    2'b01: z <= {z_sign1, 31'b0}; // Zero
                    default: z <= 32'h0;
                endcase
            end 
            // Normal case with rounding
            else begin
                // Round to nearest even
                if (guard1 && (sticky1 || z_mant1_msb[0])) begin
                    {z_exp2, z_mant2} <= {z_exp1, z_mant1_msb[22:0]} + 1;
                end else begin
                    z_exp2 <= z_exp1;
                    z_mant2 <= z_mant1_msb[22:0];
                end
                
                // Check for overflow/underflow
                if (z_exp2[7] || (&z_exp2[6:0])) begin
                    z <= {z_sign2, 8'hFF, 23'b0}; // Overflow
                end else if (z_exp2 == 0) begin
                    z <= {z_sign2, 31'b0}; // Underflow
                end else begin
                    z <= {z_sign2, z_exp2[6:0], z_mant2};
                end
            end
        end
    end

endmodule