module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // State machine
    localparam S_INPUT = 0;
    localparam S_COMPUTE = 1;
    localparam S_OUTPUT = 2;
    reg [1:0] state;

    // Input registers
    reg [23:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg a_sign, b_sign;

    // Pipeline registers
    reg [47:0] product;
    reg [7:0] exp_sum;
    reg sign_result;
    reg product_msb;

    // Special case detection (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);

    // Intermediate computations (combinational)
    wire [23:0] norm_mantissa = product_msb ? product[47:24] : product[46:23];
    wire [7:0] norm_exponent = product_msb ? (exp_sum + 1) : exp_sum;
    
    // Rounding logic
    wire guard_bit = product[22];
    wire sticky = |product[21:0];
    wire round_inc = guard_bit && (sticky || norm_mantissa[0]);
    
    // Final results
    wire [23:0] rounded_mantissa = norm_mantissa + round_inc;
    wire [7:0] final_exponent = (rounded_mantissa[23]) ? norm_exponent + 1 : norm_exponent;
    wire [22:0] final_mantissa = rounded_mantissa[22:0];
    
    // Output selection
    wire special_case = a_nan || b_nan || ((a_inf || b_inf) && (a_zero || b_zero));
    wire overflow = (&norm_exponent) || (final_exponent[7] && !norm_exponent[7]);
    wire underflow = (norm_exponent == 0) && (final_exponent == 0);
    
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {sign_result, 8'hFF, 23'b0};
    wire [31:0] zero_out = {sign_result, 31'b0};
    wire [31:0] normal_out = {sign_result, final_exponent, final_mantissa};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_INPUT;
            z <= 0;
        end else begin
            case (state)
                S_INPUT: begin
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    state <= S_COMPUTE;
                end
                
                S_COMPUTE: begin
                    // Pipeline stage 1: Multiply and exponent sum
                    product <= a_mantissa * b_mantissa;
                    exp_sum <= a_exponent + b_exponent - 8'd127;
                    sign_result <= a_sign ^ b_sign;
                    
                    // Pipeline stage 2: Normalization
                    product_msb <= product[47];
                    
                    state <= S_OUTPUT;
                end
                
                S_OUTPUT: begin
                    // Priority-based output selection
                    if (special_case) begin
                        z <= nan_out;
                    end
                    else if (a_inf || b_inf) begin
                        z <= inf_out;
                    end
                    else if (a_zero || b_zero) begin
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