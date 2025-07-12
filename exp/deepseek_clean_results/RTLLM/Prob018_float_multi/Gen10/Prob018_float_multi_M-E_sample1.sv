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

    // Pipeline registers
    reg [1:0] state;
    reg special_case_reg;
    reg [23:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg a_sign, b_sign;
    reg [47:0] product;
    reg [7:0] exp_sum;
    reg sign_result;
    
    // Parallel processing signals
    wire [7:0] exp_biased = exp_sum - 8'd127;
    wire [23:0] norm_mantissa;
    wire [7:0] norm_exponent;
    wire [23:0] rounded_mantissa;
    wire [7:0] final_exponent;
    
    // Leading zero anticipation (predicts normalization shift)
    wire [4:0] lza_count;
    lza_anticipate u_lza(
        .product(product),
        .count(lza_count)
    );
    
    // Normalization and rounding
    assign norm_mantissa = product >> (47 - lza_count - 23);
    assign norm_exponent = exp_biased - (47 - lza_count - 23);
    assign rounded_mantissa = norm_mantissa + 
                            ((norm_mantissa[0] & product[22]) | 
                            (|product[21:0]));

    // Final exponent adjustment
    assign final_exponent = (rounded_mantissa[23]) ? 
                          (norm_exponent + 1) : norm_exponent;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            z <= 0;
            special_case_reg <= 0;
        end else begin
            case (state)
                0: begin  // Stage 1: Input processing
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    // Special case detection
                    special_case_reg <= special_case;
                    
                    state <= 1;
                end
                
                1: begin  // Stage 2: Parallel processing
                    // Mantissa path
                    product <= a_mantissa * b_mantissa;
                    
                    // Exponent path
                    exp_sum <= a_exponent + b_exponent;
                    sign_result <= a_sign ^ b_sign;
                    
                    state <= 2;
                end
                
                2: begin  // Stage 3: Result merging
                    // Handle special cases with priority
                    if (special_case_reg) begin
                        if (a_nan | b_nan) begin
                            z <= 32'h7FC00000;  // Canonical NaN
                        end else if ((a_inf | b_inf) & (a_zero | b_zero)) begin
                            z <= 32'h7FC00000;  // NaN for 0*inf
                        end else if (a_inf | b_inf) begin
                            z <= {sign_result, 8'hFF, 23'b0};  // Infinity
                        end else begin  // Zero case
                            z <= {sign_result, 31'b0};
                        end
                    end else begin
                        // Check for overflow/underflow
                        if (&final_exponent | (final_exponent == 0)) begin
                            z <= {sign_result, 8'hFF, 23'b0};  // Overflow to inf
                        end else begin
                            z <= {sign_result, final_exponent, rounded_mantissa[22:0]};
                        end
                    end
                    
                    state <= 0;
                end
            endcase
        end
    end

    // Leading Zero Anticipation module
    module lza_anticipate(
        input [47:0] product,
        output reg [4:0] count
    );
        // Implementation of leading zero anticipation logic
        // This predicts the number of leading zeros in the product
        always @(*) begin
            casez (product[47:40])
                8'b1???????: count = 0;
                8'b01??????: count = 1;
                8'b001?????: count = 2;
                8'b0001????: count = 3;
                8'b00001???: count = 4;
                8'b000001??: count = 5;
                8'b0000001?: count = 6;
                8'b00000001: count = 7;
                default: count = 8;
            endcase
        end
    endmodule

endmodule