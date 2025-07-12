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
    localparam STAGE_OUT = 4;
    
    reg [2:0] stage;
    
    // Special case detection (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    wire special_case = a_nan || b_nan || ((a_inf || b_inf) && (a_zero || b_zero));
    
    // Pipeline registers
    reg [23:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg a_sign, b_sign;
    reg special_case_reg;
    
    // Wallace tree pipeline registers
    reg [47:0] pp_sum [1:0];
    reg [47:0] pp_carry [1:0];
    reg [7:0] exp_sum;
    reg sign_pipe;
    
    // Normalization stage registers
    reg [47:0] final_product;
    reg [7:0] norm_exponent;
    reg sign_norm;
    reg norm_shift;
    
    // Rounding stage registers
    reg [22:0] rounded_mantissa;
    reg [7:0] final_exponent;
    reg sign_out;
    
    // Wallace tree partial product generation
    wire [47:0] pp [23:0];
    genvar i;
    generate
        for (i = 0; i < 24; i = i + 1) begin : pp_gen
            assign pp[i] = b_mantissa[i] ? (a_mantissa << i) : 48'b0;
        end
    endgenerate
    
    // First level of 3:2 compressors
    wire [47:0] sum1, carry1;
    compressor_3_2 level1 [15:0] (
        .a(pp[0], pp[1], pp[2], pp[3], pp[4], pp[5], pp[6], pp[7],
           pp[8], pp[9], pp[10], pp[11], pp[12], pp[13], pp[14], pp[15]),
        .b(pp[16], pp[17], pp[18], pp[19], pp[20], pp[21], pp[22], pp[23],
           48'b0, 48'b0, 48'b0, 48'b0, 48'b0, 48'b0, 48'b0, 48'b0),
        .sum(sum1),
        .carry(carry1)
    );
    
    // Final adder (registered)
    always @(posedge clk) begin
        if (rst) begin
            stage <= STAGE_INPUT;
            z <= 0;
        end else begin
            case (stage)
                STAGE_INPUT: begin
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    special_case_reg <= special_case;
                    
                    // Start multiplication
                    pp_sum[0] <= sum1;
                    pp_carry[0] <= carry1 << 1;
                    exp_sum <= a_exponent + b_exponent - 8'd127;
                    sign_pipe <= a_sign ^ b_sign;
                    
                    stage <= STAGE_MULT;
                end
                
                STAGE_MULT: begin
                    // Second level compression
                    pp_sum[1] <= pp_sum[0] ^ pp_carry[0];
                    pp_carry[1] <= (pp_sum[0] & pp_carry[0]) << 1;
                    
                    // Early normalization prediction
                    norm_shift <= ~(|pp_sum[0][47:46]);
                    
                    stage <= STAGE_NORM;
                end
                
                STAGE_NORM: begin
                    // Final addition and normalization
                    final_product <= pp_sum[1] + pp_carry[1];
                    norm_exponent <= norm_shift ? (exp_sum - 1) : exp_sum;
                    sign_norm <= sign_pipe;
                    
                    stage <= STAGE_ROUND;
                end
                
                STAGE_ROUND: begin
                    // Select normalized mantissa
                    wire [23:0] pre_round = norm_shift ? final_product[46:23] : final_product[47:24];
                    
                    // Rounding logic
                    wire guard = norm_shift ? final_product[22] : final_product[23];
                    wire round = norm_shift ? final_product[21] : final_product[22];
                    wire sticky = norm_shift ? |final_product[20:0] : |final_product[21:0];
                    wire round_inc = guard & (round | sticky | pre_round[0]);
                    
                    // Apply rounding
                    rounded_mantissa <= round_inc ? pre_round[22:0] + 1 : pre_round[22:0];
                    final_exponent <= round_inc && &pre_round[22:0] ? norm_exponent + 1 : norm_exponent;
                    sign_out <= sign_norm;
                    
                    stage <= STAGE_OUT;
                end
                
                STAGE_OUT: begin
                    // Output selection
                    if (special_case_reg) begin
                        z <= 32'h7FC00000; // NaN
                    end
                    else if (a_inf || b_inf) begin
                        z <= {sign_out, 8'hFF, 23'b0}; // Infinity
                    end
                    else if (a_zero || b_zero) begin
                        z <= {sign_out, 31'b0}; // Zero
                    end
                    else if (&final_exponent || (final_exponent == 0)) begin
                        z <= {sign_out, 8'hFF, 23'b0}; // Overflow/Underflow
                    end
                    else begin
                        z <= {sign_out, final_exponent, rounded_mantissa};
                    end
                    
                    stage <= STAGE_INPUT;
                end
            endcase
        end
    end

endmodule

// 3:2 Compressor module for Wallace tree
module compressor_3_2(
    input [47:0] a [15:0],
    input [47:0] b [15:0],
    output [47:0] sum [15:0],
    output [47:0] carry [15:0]
);
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : compress
            assign sum[i] = a[i] ^ b[i];
            assign carry[i] = (a[i] & b[i]) << 1;
        end
    endgenerate
endmodule