module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stages
    localparam EXTRACT  = 3'b000;
    localparam MULTIPLY = 3'b001;
    localparam NORMALIZE = 3'b010;
    localparam ROUND    = 3'b011;
    localparam OUTPUT   = 3'b100;

    reg [2:0] state;
    
    // Pipeline registers
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [8:0] a_exponent, b_exponent, z_exponent; // 9 bits (8 + overflow)
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;  // 24x24 = 48 bits
    reg guard_bit, round_bit, sticky;
    reg special_case;

    // Combinational special case detection
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    wire any_nan = a_nan | b_nan;
    wire any_inf = a_inf | b_inf;
    wire any_zero = a_zero | b_zero;
    wire inf_zero = any_inf & any_zero;

    // Intermediate calculations
    wire [8:0] exp_sum = a_exponent + b_exponent;
    wire [8:0] exp_biased = exp_sum - 9'd127;
    wire sign_result = a_sign ^ b_sign;
    
    // Normalization
    wire product_overflow = product[47];
    wire [23:0] norm_mantissa = product_overflow ? product[47:24] : product[46:23];
    wire [8:0] norm_exponent = product_overflow ? (exp_biased + 1) : exp_biased;
    
    // Rounding
    wire round_inc = guard_bit && (round_bit || sticky || z_mantissa[0]);
    wire mantissa_overflow = &z_mantissa;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= EXTRACT;
            z <= 0;
            special_case <= 0;
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
                    
                    // Early special case detection
                    special_case <= any_nan | any_inf | any_zero;
                    
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
                    
                    // Extract rounding bits
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    sticky <= |product[20:0];
                    
                    state <= ROUND;
                end
                
                ROUND: begin
                    // Apply rounding with overflow check
                    if (round_inc && !special_case) begin
                        z_mantissa <= z_mantissa + 1;
                        if (mantissa_overflow) begin
                            z_mantissa <= {1'b1, 23'b0};
                            z_exponent <= z_exponent + 1;
                        end
                    end
                    
                    state <= OUTPUT;
                end
                
                OUTPUT: begin
                    // Output selection
                    if (any_nan || inf_zero) begin
                        z <= 32'h7FC00000;  // NaN
                    end
                    else if (any_inf) begin
                        z <= {z_sign, 8'hFF, 23'b0};  // +/- inf
                    end
                    else if (any_zero) begin
                        z <= {z_sign, 31'b0};  // +/- 0
                    end
                    else if (z_exponent[8] || (&z_exponent[7:0])) begin  // Overflow
                        z <= {z_sign, 8'hFF, 23'b0};
                    end
                    else if (z_exponent == 0) begin  // Underflow
                        z <= {z_sign, 31'b0};
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