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
    localparam STAGE_OUTPUT = 3;

    reg [1:0] stage;
    reg [23:0] a_mant, b_mant, z_mant;
    reg [7:0] a_exp, b_exp, z_exp;
    reg a_sign, b_sign, z_sign;
    reg [47:0] partial_sum [0:2]; // Wallace tree pipeline registers
    reg [47:0] final_prod;
    reg early_round;
    reg [2:0] special_case;

    // Special case detection (combinational)
    wire is_nan = (&a[30:23] && |a[22:0]) || (&b[30:23] && |b[22:0]);
    wire is_inf = (&a[30:23] && ~|a[22:0]) || (&b[30:23] && ~|b[22:0]);
    wire is_zero = (~|a[30:0]) || (~|b[30:0]);
    wire invalid = (is_inf && is_zero);

    // Exponent pre-processing
    wire [8:0] exp_sum = {1'b0,a_exp} + {1'b0,b_exp} - 9'd127;
    wire exp_overflow = exp_sum[8] || (&exp_sum[7:0]);
    wire exp_underflow = (exp_sum < 9'd126);

    // Wallace tree partial products
    wire [47:0] pp0 = b_mant[0] ? {24'b0, a_mant} : 48'b0;
    wire [47:0] pp1 = b_mant[1] ? {23'b0, a_mant, 1'b0} : 48'b0;
    wire [47:0] pp2 = b_mant[2] ? {22'b0, a_mant, 2'b0} : 48'b0;
    // ... (additional partial products omitted for brevity)

    // Early rounding prediction
    wire [22:0] sticky_bits = |b_mant[22:0] ? 23'h7FFFFF : 23'b0;
    wire early_round_needed = |(a_mant[22:0] & sticky_bits);

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
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_mant <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mant <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    // Parallel special case detection
                    special_case <= {invalid, is_nan, is_inf || is_zero};
                    early_round <= early_round_needed;
                    
                    // Initialize Wallace tree
                    partial_sum[0] <= pp0 + pp1 + pp2;
                    // ... (additional partial sums)
                    
                    stage <= STAGE_MULT;
                end
                
                STAGE_MULT: begin
                    // Wallace tree reduction stage 1
                    partial_sum[1] <= partial_sum[0][47:24] + partial_sum[0][23:0];
                    // ... (additional reduction steps)
                    
                    // Exponent pre-adjustment
                    z_exp <= exp_sum[7:0];
                    z_sign <= a_sign ^ b_sign;
                    
                    stage <= STAGE_NORM;
                end
                
                STAGE_NORM: begin
                    // Final addition and normalization
                    final_prod <= partial_sum[1] + partial_sum[2];
                    
                    // Normalize
                    if (final_prod[47]) begin
                        z_mant <= final_prod[47:24];
                        z_exp <= z_exp + 1;
                    end else begin
                        z_mant <= final_prod[46:23];
                    end
                    
                    stage <= STAGE_OUTPUT;
                end
                
                STAGE_OUTPUT: begin
                    // Apply rounding if predicted
                    if (early_round) begin
                        z_mant <= z_mant + 1;
                        if (&z_mant) begin // Handle carry
                            z_mant <= {1'b1, 23'b0};
                            z_exp <= z_exp + 1;
                        end
                    end
                    
                    // Output selection
                    casez (special_case)
                        3'b1??: z <= 32'h7FC00000; // NaN
                        3'b01?: z <= {z_sign, 8'hFF, 23'b0}; // Inf
                        3'b001: z <= {z_sign, 31'b0}; // Zero
                        default: begin
                            if (exp_overflow)
                                z <= {z_sign, 8'hFF, 23'b0};
                            else if (exp_underflow)
                                z <= {z_sign, 31'b0};
                            else
                                z <= {z_sign, z_exp, z_mant[22:0]};
                        end
                    endcase
                    
                    stage <= STAGE_INPUT;
                end
            endcase
        end
    end

endmodule