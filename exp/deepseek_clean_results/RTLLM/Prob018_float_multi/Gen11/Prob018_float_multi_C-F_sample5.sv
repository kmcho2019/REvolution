module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stages
    localparam S_EXTRACT = 0;
    localparam S_MULTIPLY = 1;
    localparam S_NORM_ROUND = 2;
    localparam S_OUTPUT = 3;

    reg [1:0] state;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [8:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;
    
    // Pipeline registers
    reg [47:0] product_reg;
    reg [8:0] exp_sum_reg;
    reg sign_reg;
    reg guard_bit, round_bit, sticky;
    
    // Special case detection (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    
    // Exponent calculation
    wire [8:0] exp_sum = {1'b0, a_exponent} + {1'b0, b_exponent} - 9'd127;
    
    // Normalization
    wire product_msb = product_reg[47];
    wire [23:0] norm_mantissa = product_msb ? product_reg[47:24] : product_reg[46:23];
    wire [8:0] norm_exponent = product_msb ? (exp_sum_reg + 1) : exp_sum_reg;
    
    // Rounding (round to nearest even)
    wire round_inc = guard_bit && (round_bit || sticky || z_mantissa[0]);
    
    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {z_sign, 8'hFF, 23'b0};
    wire [31:0] zero_out = {z_sign, 31'b0};
    wire [31:0] normal_out = {z_sign, z_exponent[7:0], z_mantissa[22:0]};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_EXTRACT;
            z <= 0;
        end else begin
            case (state)
                S_EXTRACT: begin
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    state <= S_MULTIPLY;
                end
                
                S_MULTIPLY: begin
                    // Perform multiplication and register results
                    product <= a_mantissa * b_mantissa;
                    exp_sum_reg <= exp_sum;
                    sign_reg <= a_sign ^ b_sign;
                    
                    state <= S_NORM_ROUND;
                end
                
                S_NORM_ROUND: begin
                    // Register multiplication result
                    product_reg <= product;
                    
                    // Normalize
                    z_mantissa <= norm_mantissa;
                    z_exponent <= norm_exponent;
                    z_sign <= sign_reg;
                    
                    // Extract rounding bits
                    guard_bit <= product_reg[22];
                    round_bit <= product_reg[21];
                    sticky <= |product_reg[20:0];
                    
                    // Apply rounding if needed
                    if (round_inc) begin
                        z_mantissa <= z_mantissa + 1;
                        if (&z_mantissa) begin // Handle mantissa overflow
                            z_mantissa <= {1'b1, 23'b0};
                            z_exponent <= z_exponent + 1;
                        end
                    end
                    
                    state <= S_OUTPUT;
                end
                
                S_OUTPUT: begin
                    // Priority-based output selection
                    if (a_nan || b_nan) begin
                        z <= nan_out;
                    end
                    else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        z <= nan_out;
                    end
                    else if (a_inf || b_inf) begin
                        z <= inf_out;
                    end
                    else if (a_zero || b_zero) begin
                        z <= zero_out;
                    end
                    else if (z_exponent[8] || &z_exponent[7:0]) begin // Overflow
                        z <= inf_out;
                    end
                    else if (z_exponent == 0) begin // Underflow
                        z <= zero_out;
                    end
                    else begin
                        z <= normal_out;
                    end
                    
                    state <= S_EXTRACT;
                end
            endcase
        end
    end

endmodule