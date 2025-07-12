module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // State machine
    typedef enum {IDLE, MULTIPLY, NORMALIZE} state_t;
    state_t state;

    // Special case detection (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    wire special_case = a_nan || b_nan || ((a_inf || b_inf) && (a_zero || b_zero));
    wire inf_case = (a_inf || b_inf) && ~special_case;
    wire zero_case = (a_zero || b_zero) && ~special_case;
    
    // Pipeline registers
    reg [23:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg a_sign, b_sign;
    reg [47:0] product;
    reg [7:0] exp_sum;
    reg sign_reg;
    
    // Normalization logic (combinational)
    wire product_msb = product[47];
    wire [23:0] norm_mantissa = product_msb ? product[47:24] : product[46:23];
    wire [7:0] norm_exponent = product_msb ? (exp_sum + 1) : exp_sum;
    
    // Rounding logic (combinational)
    wire guard_bit = product[22];
    wire round_bit = product[21];
    wire sticky = |product[20:0];
    wire round_inc = guard_bit && (round_bit || sticky);
    wire [23:0] rounded_mantissa = round_inc ? norm_mantissa + 1 : norm_mantissa;
    
    // Overflow/underflow detection
    wire overflow = (norm_exponent >= 255) || (&norm_exponent && round_inc);
    wire underflow = (norm_exponent == 0);
    
    // Output selection (combinational)
    wire [31:0] normal_out = {sign_reg, 
                             overflow ? 8'hFF : underflow ? 8'h00 : norm_exponent,
                             overflow ? 23'b0 : underflow ? 23'b0 : rounded_mantissa[22:0]};
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 0;
            {a_mantissa, b_mantissa, a_exponent, b_exponent} <= 0;
            {a_sign, b_sign, product, exp_sum, sign_reg} <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (special_case) begin
                        z <= a_nan || b_nan ? {1'b0, 8'hFF, 1'b1, 22'b0} :  // NaN
                            inf_case ? {a_sign ^ b_sign, 8'hFF, 23'b0} :     // Inf
                            {a_sign ^ b_sign, 31'b0};                        // Zero
                    end else begin
                        // Extract components
                        a_sign <= a[31];
                        b_sign <= b[31];
                        a_exponent <= a[30:23];
                        b_exponent <= b[30:23];
                        a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                        b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                        state <= MULTIPLY;
                    end
                end
                
                MULTIPLY: begin
                    // Perform multiplication and exponent calculation
                    product <= a_mantissa * b_mantissa;
                    exp_sum <= a_exponent + b_exponent - 8'd127;
                    sign_reg <= a_sign ^ b_sign;
                    state <= NORMALIZE;
                end
                
                NORMALIZE: begin
                    z <= normal_out;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule