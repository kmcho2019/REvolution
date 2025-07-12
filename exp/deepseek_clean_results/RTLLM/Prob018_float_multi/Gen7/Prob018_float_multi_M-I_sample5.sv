module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stages
    localparam STAGE_INPUT = 0;
    localparam STAGE_MULT = 1;
    localparam STAGE_NORM = 2;
    localparam STAGE_ROUND = 3;
    localparam STAGE_OUTPUT = 4;

    reg [2:0] stage;
    reg [23:0] a_mant, b_mant, z_mant;
    reg [8:0] a_exp, b_exp, z_exp;  // Extended to 9 bits for easier overflow detection
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;
    reg guard, round, sticky;
    reg [3:0] special_case;

    // Input processing
    wire a_is_zero = ~|a[30:0];
    wire b_is_zero = ~|b[30:0];
    wire a_is_inf = &a[30:23] & ~|a[22:0];
    wire b_is_inf = &b[30:23] & ~|b[22:0];
    wire a_is_nan = &a[30:23] & |a[22:0];
    wire b_is_nan = &b[30:23] & |b[22:0];
    wire a_is_denormal = ~|a[30:23] & |a[22:0];
    wire b_is_denormal = ~|b[30:23] & |b[22:0];

    // Special case detection
    wire is_nan = a_is_nan | b_is_nan | (a_is_inf & b_is_zero) | (b_is_inf & a_is_zero);
    wire is_inf = (a_is_inf | b_is_inf) & ~is_nan;
    wire is_zero = (a_is_zero | b_is_zero) & ~is_nan & ~is_inf;

    // Exponent calculation
    wire [9:0] exp_sum = {1'b0, (a_is_denormal ? 8'd1 : a[30:23])} + 
                         {1'b0, (b_is_denormal ? 8'd1 : b[30:23])} - 10'd127;

    // Mantissa processing
    wire [23:0] a_mantissa = a_is_denormal ? {1'b0, a[22:0]} : 
                            (|a[30:23] ? {1'b1, a[22:0]} : 24'b0);
    wire [23:0] b_mantissa = b_is_denormal ? {1'b0, b[22:0]} : 
                            (|b[30:23] ? {1'b1, b[22:0]} : 24'b0);

    // Wallace tree multiplier (24x24 bits)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= STAGE_INPUT;
            z <= 0;
            special_case <= 0;
        end else begin
            case (stage)
                STAGE_INPUT: begin
                    // Process inputs
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a_is_denormal ? 8'd1 : a[30:23];
                    b_exp <= b_is_denormal ? 8'd1 : b[30:23];
                    a_mant <= a_mantissa;
                    b_mant <= b_mantissa;
                    
                    // Detect special cases
                    special_case <= {is_nan, is_inf, is_zero, a_is_denormal | b_is_denormal};
                    
                    stage <= STAGE_MULT;
                end
                
                STAGE_MULT: begin
                    // Perform full 24x24 multiplication
                    product <= a_mant * b_mant;
                    
                    // Calculate exponent
                    z_exp <= exp_sum[7:0];
                    z_sign <= a_sign ^ b_sign;
                    
                    stage <= STAGE_NORM;
                end
                
                STAGE_NORM: begin
                    // Normalize product
                    if (product[47]) begin
                        z_mant <= product[47:24];
                        z_exp <= z_exp + 1;
                        guard <= product[23];
                        round <= product[22];
                        sticky <= |product[21:0];
                    end else begin
                        z_mant <= product[46:23];
                        guard <= product[22];
                        round <= product[21];
                        sticky <= |product[20:0];
                    end
                    
                    stage <= STAGE_ROUND;
                end
                
                STAGE_ROUND: begin
                    // IEEE-754 rounding (round to nearest even)
                    if (guard && (round | sticky | z_mant[0])) begin
                        z_mant <= z_mant + 1;
                        if (&z_mant) begin // Handle carry
                            z_mant <= {1'b1, 23'b0};
                            z_exp <= z_exp + 1;
                        end
                    end
                    
                    stage <= STAGE_OUTPUT;
                end
                
                STAGE_OUTPUT: begin
                    // Handle overflow/underflow
                    if (z_exp[8] || &z_exp[7:0]) begin // Overflow
                        z <= {z_sign, 8'hFF, 23'b0};
                    end else if (z_exp == 0) begin // Underflow
                        z <= {z_sign, 31'b0};
                    end else begin
                        // Output selection
                        casez (special_case)
                            4'b1???: z <= 32'h7FC00000; // NaN
                            4'b01??: z <= {z_sign, 8'hFF, 23'b0}; // Inf
                            4'b001?: z <= {z_sign, 31'b0}; // Zero
                            4'b0001: begin // Denormal result
                                if (z_exp < 8'd126) begin
                                    z <= {z_sign, 31'b0}; // Flush to zero
                                end else begin
                                    z <= {z_sign, z_exp, z_mant[22:0]};
                                end
                            end
                            default: z <= {z_sign, z_exp, z_mant[22:0]};
                        endcase
                    end
                    
                    stage <= STAGE_INPUT;
                end
            endcase
        end
    end

endmodule