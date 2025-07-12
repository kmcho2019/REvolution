module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stages
    localparam STAGE_INPUT = 0;
    localparam STAGE_MULTIPLY = 1;
    localparam STAGE_NORM = 2;

    reg [1:0] stage;
    
    // Pipeline registers
    reg [23:0] a_mantissa_p1, b_mantissa_p1;
    reg [8:0] a_exponent_p1, b_exponent_p1;
    reg a_sign_p1, b_sign_p1;
    reg special_case_p1, inf_case_p1, zero_case_p1;
    
    reg [47:0] product_p2;
    reg [8:0] exp_sum_p2;
    reg sign_p2;
    reg special_case_p2, inf_case_p2, zero_case_p2;
    
    // Special case detection (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    
    // Early termination signals
    wire special_case = a_nan || b_nan || ((a_inf || b_inf) && (a_zero || b_zero));
    wire inf_case = (a_inf || b_inf) && !special_case;
    wire zero_case = (a_zero || b_zero) && !special_case;
    
    // Partial products for pipelined multiplier
    wire [23:0] pp0 = b_mantissa_p1[0] ? a_mantissa_p1 : 0;
    wire [23:0] pp1 = b_mantissa_p1[1] ? a_mantissa_p1 : 0;
    wire [23:0] pp2 = b_mantissa_p1[2] ? a_mantissa_p1 : 0;
    wire [23:0] pp3 = b_mantissa_p1[3] ? a_mantissa_p1 : 0;
    wire [23:0] pp4 = b_mantissa_p1[4] ? a_mantissa_p1 : 0;
    wire [23:0] pp5 = b_mantissa_p1[5] ? a_mantissa_p1 : 0;
    wire [23:0] pp6 = b_mantissa_p1[6] ? a_mantissa_p1 : 0;
    wire [23:0] pp7 = b_mantissa_p1[7] ? a_mantissa_p1 : 0;
    
    // Stage 2: Sum partial products
    wire [47:0] product = 
        ({24'b0, pp0}) +
        ({23'b0, pp1, 1'b0}) +
        ({22'b0, pp2, 2'b0}) +
        ({21'b0, pp3, 3'b0}) +
        ({20'b0, pp4, 4'b0}) +
        ({19'b0, pp5, 5'b0}) +
        ({18'b0, pp6, 6'b0}) +
        ({17'b0, pp7, 7'b0});
    
    // Normalization and rounding
    wire product_msb = product_p2[47];
    wire [23:0] norm_mantissa = product_msb ? product_p2[47:24] : product_p2[46:23];
    wire [8:0] norm_exponent = product_msb ? (exp_sum_p2 + 1) : exp_sum_p2;
    
    // Simplified rounding (only look at LSB and next bit)
    wire round_up = product_p2[22] && (product_p2[21] || product_p2[0]);
    wire [23:0] final_mantissa = round_up ? norm_mantissa + 1 : norm_mantissa;
    wire [8:0] final_exponent = norm_exponent + (round_up && &norm_mantissa);
    
    // Overflow/underflow detection
    wire overflow = final_exponent[8] || &final_exponent[7:0];
    wire underflow = (final_exponent[8:0] == 0);
    
    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {sign_p2, 8'hFF, 23'b0};
    wire [31:0] zero_out = {sign_p2, 31'b0};
    wire [31:0] normal_out = {sign_p2, final_exponent[7:0], final_mantissa[22:0]};
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= STAGE_INPUT;
            z <= 0;
        end else begin
            case (stage)
                STAGE_INPUT: begin
                    // Stage 1: Input and special case detection
                    a_sign_p1 <= a[31];
                    b_sign_p1 <= b[31];
                    a_exponent_p1 <= a[30:23];
                    b_exponent_p1 <= b[30:23];
                    a_mantissa_p1 <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa_p1 <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    special_case_p1 <= special_case;
                    inf_case_p1 <= inf_case;
                    zero_case_p1 <= zero_case;
                    
                    stage <= STAGE_MULTIPLY;
                end
                
                STAGE_MULTIPLY: begin
                    // Stage 2: Multiplication and exponent sum
                    product_p2 <= product;
                    exp_sum_p2 <= a_exponent_p1 + b_exponent_p1 - 9'd127;
                    sign_p2 <= a_sign_p1 ^ b_sign_p1;
                    
                    special_case_p2 <= special_case_p1;
                    inf_case_p2 <= inf_case_p1;
                    zero_case_p2 <= zero_case_p1;
                    
                    stage <= STAGE_NORM;
                end
                
                STAGE_NORM: begin
                    // Stage 3: Normalization and output
                    if (special_case_p2) begin
                        z <= nan_out;
                    end
                    else if (inf_case_p2) begin
                        z <= inf_out;
                    end
                    else if (zero_case_p2) begin
                        z <= zero_out;
                    end
                    else if (overflow) begin
                        z <= inf_out;
                    end
                    else if (underflow) begin
                        z <= zero_out;
                    end
                    else begin
                        z <= normal_out;
                    end
                    
                    stage <= STAGE_INPUT;
                end
            endcase
        end
    end

endmodule