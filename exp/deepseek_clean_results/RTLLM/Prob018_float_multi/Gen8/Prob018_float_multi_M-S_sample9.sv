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
    reg [22:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;
    
    // Special case detection
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    
    // Intermediate calculations
    wire [8:0] exp_sum = {1'b0, a_exponent} + {1'b0, b_exponent} - 8'd127;
    wire sign_result = a_sign ^ b_sign;
    
    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {z_sign, 8'hFF, 23'b0};
    wire [31:0] zero_out = {z_sign, 31'b0};
    wire [31:0] normal_out = {z_sign, z_exponent, z_mantissa};

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
                    a_mantissa <= a[22:0];
                    b_mantissa <= b[22:0];
                    
                    state <= S_MULTIPLY;
                end
                
                S_MULTIPLY: begin
                    // Multiply mantissas (with implicit 1)
                    product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                    z_sign <= sign_result;
                    
                    state <= S_NORM_ROUND;
                end
                
                S_NORM_ROUND: begin
                    // Normalize and round
                    if (product[47]) begin
                        z_mantissa <= product[46:24] + (product[23] & (product[22] | |product[21:0]));
                        z_exponent <= exp_sum[7:0] + 1;
                    end else begin
                        z_mantissa <= product[45:23] + (product[22] & (product[21] | |product[20:0]));
                        z_exponent <= exp_sum[7:0];
                    end
                    
                    // Handle overflow from rounding
                    if (z_mantissa[23]) begin
                        z_mantissa <= z_mantissa >> 1;
                        z_exponent <= z_exponent + 1;
                    end
                    
                    state <= S_OUTPUT;
                end
                
                S_OUTPUT: begin
                    // Handle special cases
                    if (a_nan || b_nan) z <= nan_out;
                    else if ((a_inf || b_inf) && (a_zero || b_zero)) z <= nan_out;
                    else if (a_inf || b_inf) z <= inf_out;
                    else if (a_zero || b_zero) z <= zero_out;
                    else if (&z_exponent || (exp_sum[8])) z <= inf_out; // Overflow
                    else if (z_exponent == 0) z <= zero_out; // Underflow
                    else z <= normal_out;
                    
                    state <= S_EXTRACT;
                end
            endcase
        end
    end

endmodule