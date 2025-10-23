module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stages
    localparam S_INPUT = 0;
    localparam S_MULTIPLY = 1;
    localparam S_NORMALIZE = 2;
    localparam S_OUTPUT = 3;

    reg [1:0] state;
    
    // Input registers
    reg [23:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg a_sign, b_sign;
    reg input_special_case, input_a_inf, input_b_inf, input_a_zero, input_b_zero;
    
    // Multiply stage registers
    reg [47:0] product;
    reg [7:0] exp_sum;
    reg multiply_sign;
    reg multiply_special_case;
    
    // Normalize stage registers
    reg [23:0] norm_mantissa;
    reg [7:0] norm_exponent;
    reg normalize_sign;
    reg normalize_special_case;
    
    // Special case detection (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    
    // Clock gating for multiplier
    wire multiply_enable = (state == S_INPUT);
    wire gated_clk = clk & multiply_enable;
    
    // Rounding bits (combinational)
    wire guard_bit = product[22];
    wire round_bit = product[21];
    wire sticky = |product[20:0];
    wire round_inc = guard_bit && (round_bit || sticky);
    
    // Output selection (combinational)
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {normalize_sign, 8'hFF, 23'b0};
    wire [31:0] zero_out = {normalize_sign, 31'b0};
    wire [31:0] normal_out = {normalize_sign, norm_exponent[7:0], 
                             (round_inc ? norm_mantissa[22:0] + 1 : norm_mantissa[22:0])};
    
    // Overflow/underflow detection
    wire overflow = (norm_exponent >= 8'hFF);
    wire underflow = (norm_exponent == 0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_INPUT;
            z <= 0;
        end else begin
            case (state)
                S_INPUT: begin
                    // Extract components and detect special cases early
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    input_special_case <= a_nan || b_nan || ((a_inf || b_inf) && (a_zero || b_zero));
                    input_a_inf <= a_inf;
                    input_b_inf <= b_inf;
                    input_a_zero <= a_zero;
                    input_b_zero <= b_zero;
                    
                    state <= S_MULTIPLY;
                end
                
                S_MULTIPLY: begin
                    // Multiply mantissas (clock-gated)
                    product <= a_mantissa * b_mantissa;
                    exp_sum <= a_exponent + b_exponent - 8'd127;
                    multiply_sign <= a_sign ^ b_sign;
                    multiply_special_case <= input_special_case;
                    
                    state <= S_NORMALIZE;
                end
                
                S_NORMALIZE: begin
                    // Normalize product
                    norm_mantissa <= product[47] ? product[47:24] : product[46:23];
                    norm_exponent <= product[47] ? (exp_sum + 1) : exp_sum;
                    normalize_sign <= multiply_sign;
                    normalize_special_case <= multiply_special_case;
                    
                    state <= S_OUTPUT;
                end
                
                S_OUTPUT: begin
                    // Handle output with priority
                    if (normalize_special_case) begin
                        z <= nan_out;
                    end
                    else if (input_a_inf || input_b_inf) begin
                        z <= inf_out;
                    end
                    else if (input_a_zero || input_b_zero) begin
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
                    
                    state <= S_INPUT;
                end
            endcase
        end
    end

endmodule