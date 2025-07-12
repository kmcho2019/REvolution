module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // State encoding
    localparam EXTRACT = 0;
    localparam MULTIPLY1 = 1;
    localparam MULTIPLY2 = 2;
    localparam NORMALIZE = 3;
    localparam OUTPUT = 4;

    reg [2:0] state, next_state;
    
    // Pipeline registers
    reg [23:0] a_mantissa, b_mantissa;
    reg [8:0] a_exponent, b_exponent;
    reg a_sign, b_sign;
    
    // Intermediate results
    reg [23:0] z_mantissa;
    reg [8:0] z_exponent;
    reg z_sign;
    reg [47:0] partial_product, final_product;
    reg guard_bit, round_bit, sticky;
    
    // Combinational signals
    wire [8:0] exp_sum = a_exponent + b_exponent;
    wire [8:0] exp_biased = exp_sum - 9'd127;
    wire sign_result = a_sign ^ b_sign;
    
    // Special case detection (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    
    // Normalization signals
    wire [23:0] norm_mantissa = final_product[47] ? final_product[47:24] : final_product[46:23];
    wire [8:0] norm_exponent = final_product[47] ? (exp_biased + 1) : exp_biased;
    wire round_inc = guard_bit && (round_bit || sticky || z_mantissa[0]);
    
    // Output selection (continuous assignments)
    wire is_nan = a_nan || b_nan || ((a_inf || b_inf) && (a_zero || b_zero));
    wire is_inf = (a_inf || b_inf) && !is_nan;
    wire is_zero = (a_zero || b_zero) && !is_nan;
    wire overflow = z_exponent[8] || (&z_exponent[7:0]);
    wire underflow = (z_exponent == 0);
    
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {z_sign, 8'hFF, 23'b0};
    wire [31:0] zero_out = {z_sign, 31'b0};
    wire [31:0] normal_out = {z_sign, z_exponent[7:0], z_mantissa[22:0]};
    
    // Next state logic
    always @(*) begin
        case (state)
            EXTRACT: next_state = MULTIPLY1;
            MULTIPLY1: next_state = MULTIPLY2;
            MULTIPLY2: next_state = NORMALIZE;
            NORMALIZE: next_state = OUTPUT;
            OUTPUT: next_state = EXTRACT;
            default: next_state = EXTRACT;
        endcase
    end
    
    // State machine and pipeline registers
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= EXTRACT;
            z <= 0;
        end else begin
            state <= next_state;
            
            case (state)
                EXTRACT: begin
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= {1'b0, a[30:23]};
                    b_exponent <= {1'b0, b[30:23]};
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                end
                
                MULTIPLY1: begin
                    // First stage of multiplication (partial products)
                    partial_product <= a_mantissa[11:0] * b_mantissa;
                    z_exponent <= exp_biased;
                    z_sign <= sign_result;
                end
                
                MULTIPLY2: begin
                    // Second stage of multiplication (final sum)
                    final_product <= (a_mantissa[23:12] * b_mantissa) << 12 + partial_product;
                    sticky <= |b_mantissa[11:0]; // Early sticky bit
                end
                
                NORMALIZE: begin
                    // Normalize and prepare rounding
                    z_mantissa <= norm_mantissa;
                    z_exponent <= norm_exponent;
                    guard_bit <= final_product[22];
                    round_bit <= final_product[21];
                    sticky <= sticky | (final_product[47] ? |final_product[23:0] : |final_product[22:0]);
                end
                
                OUTPUT: begin
                    // Apply rounding if needed
                    if (round_inc) begin
                        {z_exponent[0], z_mantissa} <= z_mantissa + 1;
                        if (&z_mantissa) begin // Mantissa overflow
                            z_mantissa <= {1'b1, 23'b0};
                            z_exponent <= z_exponent + 1;
                        end
                    end
                    
                    // Output selection
                    case (1'b1)
                        is_nan: z <= nan_out;
                        is_inf: z <= inf_out;
                        is_zero: z <= zero_out;
                        overflow: z <= inf_out;
                        underflow: z <= zero_out;
                        default: z <= normal_out;
                    endcase
                end
            endcase
        end
    end

endmodule