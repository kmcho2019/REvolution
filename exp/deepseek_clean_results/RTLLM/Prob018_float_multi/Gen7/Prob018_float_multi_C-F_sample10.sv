module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stages
    localparam EXTRACT = 0;
    localparam MULTIPLY = 1;
    localparam NORMALIZE = 2;
    localparam ROUND = 3;
    localparam OUTPUT = 4;

    reg [2:0] state;
    
    // Pipeline registers
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [8:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;
    reg guard_bit, sticky;
    
    // Special case detection (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    wire special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;
    
    // Intermediate calculations
    wire [8:0] exp_sum = a_exponent + b_exponent;
    wire [8:0] exp_biased = exp_sum - 9'd127;
    wire sign_result = a_sign ^ b_sign;
    
    // Normalization signals
    wire product_msb = product[47];
    wire [23:0] norm_mantissa = product_msb ? product[47:24] : product[46:23];
    wire [8:0] norm_exponent = product_msb ? (exp_biased + 1) : exp_biased;
    
    // Rounding signals
    wire round_up = guard_bit && (sticky || z_mantissa[0]);
    wire mantissa_overflow = &z_mantissa;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= EXTRACT;
            z <= 0;
        end else begin
            case (state)
                EXTRACT: begin
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= {1'b0, a[30:23]};
                    b_exponent <= {1'b0, b[30:23]};
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    state <= MULTIPLY;
                end
                
                MULTIPLY: begin
                    // Perform multiplication
                    product <= a_mantissa * b_mantissa;
                    z_exponent <= exp_biased;
                    z_sign <= sign_result;
                    
                    state <= NORMALIZE;
                end
                
                NORMALIZE: begin
                    // Normalize result
                    z_mantissa <= norm_mantissa;
                    z_exponent <= norm_exponent;
                    
                    // Capture rounding bits
                    guard_bit <= product[22];
                    sticky <= |product[21:0];
                    
                    state <= ROUND;
                end
                
                ROUND: begin
                    // Apply rounding with overflow protection
                    if (round_up) begin
                        z_mantissa <= z_mantissa + 1;
                        if (mantissa_overflow) begin
                            z_mantissa <= {1'b1, 23'b0};
                            z_exponent <= z_exponent + 1;
                        end
                    end
                    
                    state <= OUTPUT;
                end
                
                OUTPUT: begin
                    // Priority-based output selection
                    if (a_nan || b_nan) begin
                        z <= 32'h7FC00000;  // NaN
                    end
                    else if ((a_inf || b_inf) && (a_zero || b_zero)) begin
                        z <= 32'h7FC00000;  // NaN
                    end
                    else if (a_inf || b_inf) begin
                        z <= {z_sign, 8'hFF, 23'b0};  // Infinity
                    end
                    else if (a_zero || b_zero) begin
                        z <= {z_sign, 31'b0};  // Zero
                    end
                    else if (z_exponent[8] || (&z_exponent[7:0])) begin
                        z <= {z_sign, 8'hFF, 23'b0};  // Overflow
                    end
                    else if (~|z_exponent[7:0]) begin
                        z <= {z_sign, 31'b0};  // Underflow
                    end
                    else begin
                        z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                    end
                    
                    state <= EXTRACT;
                end
            endcase
        end
    end

endmodule