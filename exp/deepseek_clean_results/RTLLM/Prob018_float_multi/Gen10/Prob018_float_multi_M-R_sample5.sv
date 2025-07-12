module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // State definitions
    localparam IDLE = 0;
    localparam DECOMPOSE = 1;
    localparam MULTIPLY = 2;
    localparam NORMALIZE = 3;
    localparam ROUND = 4;
    reg [2:0] state;

    // Input decomposition
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Pipeline registers
    reg [23:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg a_s, b_s;
    
    reg [47:0] product;
    reg [8:0] exp_sum;
    reg sign_inter;
    
    reg [47:0] product_reg;
    reg [8:0] exp_sum_reg;
    reg sign_reg;
    
    reg [23:0] z_mantissa;
    reg [8:0] z_exponent;
    reg z_sign;
    reg guard_bit, round_bit, sticky;

    // Special case detection (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a_exp) && (a_frac == 0);
    wire b_inf = (&b_exp) && (b_frac == 0);
    wire a_nan = (&a_exp) && (|a_frac);
    wire b_nan = (&b_exp) && (|b_frac);
    wire special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;

    // Exponent calculation
    wire [8:0] exp_biased = {1'b0, a_exponent} + {1'b0, b_exponent} - 9'd127;

    // Multiplication
    wire [47:0] product_inter = a_mantissa * b_mantissa;

    // Normalization
    wire product_msb = product_reg[47];
    wire [23:0] norm_mantissa = product_msb ? product_reg[47:24] : product_reg[46:23];
    wire [8:0] norm_exponent = product_msb ? (exp_sum_reg + 1) : exp_sum_reg;

    // Rounding
    wire round_inc = guard_bit && (round_bit || sticky || z_mantissa[0]);

    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {z_sign, 8'hFF, 23'b0};
    wire [31:0] zero_out = {z_sign, 31'b0};
    wire [31:0] normal_out = {z_sign, z_exponent[7:0], z_mantissa[22:0]};

    // State machine
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 0;
        end else begin
            case (state)
                IDLE: begin
                    state <= DECOMPOSE;
                end
                
                DECOMPOSE: begin
                    a_s <= a_sign;
                    b_s <= b_sign;
                    a_exponent <= a_exp;
                    b_exponent <= b_exp;
                    a_mantissa <= (|a_exp) ? {1'b1, a_frac} : {1'b0, a_frac};
                    b_mantissa <= (|b_exp) ? {1'b1, b_frac} : {1'b0, b_frac};
                    state <= MULTIPLY;
                end
                
                MULTIPLY: begin
                    product <= product_inter;
                    exp_sum <= exp_biased;
                    sign_inter <= a_s ^ b_s;
                    state <= NORMALIZE;
                end
                
                NORMALIZE: begin
                    product_reg <= product;
                    exp_sum_reg <= exp_sum;
                    sign_reg <= sign_inter;
                    state <= ROUND;
                end
                
                ROUND: begin
                    z_mantissa <= norm_mantissa;
                    z_exponent <= norm_exponent;
                    z_sign <= sign_reg;
                    
                    guard_bit <= product_reg[22];
                    round_bit <= product_reg[21];
                    sticky <= |product_reg[20:0];
                    
                    state <= IDLE;
                end
            endcase
        end
    end

    // Output generation (combinational)
    always @(*) begin
        if (state == ROUND) begin
            if (a_nan || b_nan) z = nan_out;
            else if ((a_inf || b_inf) && (a_zero || b_zero)) z = nan_out;
            else if (a_inf || b_inf) z = inf_out;
            else if (a_zero || b_zero) z = zero_out;
            else if (&z_exponent[7:0] || z_exponent[8]) z = inf_out;  // Overflow
            else if (z_exponent == 0) z = zero_out;  // Underflow
            else z = normal_out;
        end
    end

    // Rounding application (combinational)
    always @(*) begin
        if (state == ROUND && round_inc) begin
            z_mantissa = z_mantissa + 1;
            if (&z_mantissa) begin // Mantissa overflow
                z_mantissa = {1'b1, 23'b0};
                z_exponent = z_exponent + 1;
            end
        end
    end

endmodule