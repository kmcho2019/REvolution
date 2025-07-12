module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stages
    localparam S_EXTRACT = 0;
    localparam S_PARTIAL_MUL = 1;
    localparam S_ACCUMULATE = 2;
    localparam S_NORMALIZE = 3;
    localparam S_OUTPUT = 4;

    reg [2:0] state;
    reg [15:0] a_upper, b_upper;
    reg [7:0] a_lower, b_lower;
    reg [8:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    
    // Partial products
    reg [31:0] pp_uu; // Upper x Upper
    reg [23:0] pp_ul; // Upper x Lower
    reg [23:0] pp_lu; // Lower x Upper
    reg [15:0] pp_ll; // Lower x Lower
    
    // Accumulated product
    reg [47:0] product;
    reg [8:0] exp_sum_reg;
    
    // Rounding bits
    reg guard_bit, round_bit, sticky;
    
    // Special case detection (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    wire special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;
    
    // Special case result
    wire [31:0] special_result = 
        (a_nan | b_nan | (a_inf & b_zero) | (a_zero & b_inf)) ? {1'b0, 8'hFF, 1'b1, 22'b0} : // NaN
        (a_inf | b_inf) ? {a_sign ^ b_sign, 8'hFF, 23'b0} : // Inf
        {a_sign ^ b_sign, 31'b0}; // Zero
    
    // Normalization
    wire product_msb = product[47];
    wire [22:0] norm_mantissa = product_msb ? product[46:24] : product[45:23];
    wire [8:0] norm_exponent = product_msb ? (exp_sum_reg + 1) : exp_sum_reg;
    
    // Rounding
    wire round_inc = guard_bit && (round_bit || sticky || norm_mantissa[0]);
    
    // Output selection
    wire [31:0] normal_out = {z_sign, norm_exponent[7:0], norm_mantissa};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_EXTRACT;
            z <= 0;
        end else if (special_case) begin
            // Bypass pipeline for special cases
            z <= special_result;
        end else begin
            case (state)
                S_EXTRACT: begin
                    // Extract and prepare components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    
                    // Handle denormals
                    a_upper <= (|a[30:23]) ? {1'b1, a[22:8]} : {1'b0, a[22:8]};
                    b_upper <= (|b[30:23]) ? {1'b1, b[22:8]} : {1'b0, b[22:8]};
                    a_lower <= a[7:0];
                    b_lower <= b[7:0];
                    
                    // Calculate exponent sum with bias
                    exp_sum_reg <= (a_exponent + b_exponent) - 9'd127;
                    z_sign <= a_sign ^ b_sign;
                    
                    state <= S_PARTIAL_MUL;
                end
                
                S_PARTIAL_MUL: begin
                    // Compute partial products
                    pp_uu <= a_upper * b_upper;
                    pp_ul <= a_upper * b_lower;
                    pp_lu <= a_lower * b_upper;
                    pp_ll <= a_lower * b_lower;
                    
                    state <= S_ACCUMULATE;
                end
                
                S_ACCUMULATE: begin
                    // Accumulate partial products with proper alignment
                    product <= {pp_uu, 16'b0} + 
                              {8'b0, pp_ul, 8'b0} + 
                              {8'b0, pp_lu, 8'b0} + 
                              {16'b0, pp_ll};
                    
                    // Extract rounding bits
                    guard_bit <= product[23];
                    round_bit <= product[22];
                    sticky <= |product[21:0];
                    
                    state <= S_NORMALIZE;
                end
                
                S_NORMALIZE: begin
                    // Apply rounding if needed
                    if (round_inc) begin
                        if (product_msb) begin
                            product[46:24] <= product[46:24] + 1;
                            if (&product[46:24]) // Overflow in mantissa
                                exp_sum_reg <= exp_sum_reg + 1;
                        end else begin
                            product[45:23] <= product[45:23] + 1;
                            if (&product[45:23]) // Overflow in mantissa
                                exp_sum_reg <= exp_sum_reg + 1;
                        end
                    end
                    
                    state <= S_OUTPUT;
                end
                
                S_OUTPUT: begin
                    // Handle normal output with overflow/underflow checks
                    if (&norm_exponent[7:0] || norm_exponent[8]) begin // Overflow
                        z <= {z_sign, 8'hFF, 23'b0};
                    end else if (norm_exponent == 0) begin // Underflow
                        z <= {z_sign, 31'b0};
                    end else begin
                        z <= normal_out;
                    end
                    
                    state <= S_EXTRACT;
                end
            endcase
        end
    end

endmodule