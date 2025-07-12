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
    localparam S_OUTPUT = 2;

    reg [1:0] state;
    reg [22:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg a_sign, b_sign;
    reg [46:0] product;  // 23x23 + 1 bit = 47 bits
    reg z_sign;
    reg [7:0] z_exponent;
    reg [22:0] z_mantissa;
    
    // Special case detection
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    
    // Intermediate calculations
    wire [8:0] exp_sum = {1'b0, a_exponent} + {1'b0, b_exponent} - 9'd127;
    wire sign_result = a_sign ^ b_sign;
    wire product_msb = product[46];
    
    // Combined normalization and rounding
    wire [23:0] norm_mantissa = product_msb ? product[46:23] : product[45:22];
    wire [8:0] norm_exponent = product_msb ? (exp_sum + 1) : exp_sum;
    wire round_inc = product[22] && (product[21] || |product[20:0] || norm_mantissa[0]);
    
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
                    product <= ({1'b1, a_mantissa} * {1'b1, b_mantissa});
                    z_sign <= sign_result;
                    
                    state <= S_OUTPUT;
                end
                
                S_OUTPUT: begin
                    // Normalize and round
                    if (round_inc) begin
                        z_mantissa <= norm_mantissa[23:1] + 1;
                        z_exponent <= norm_exponent[7:0] + (norm_mantissa[23:1] == 23'h7FFFFF);
                    end else begin
                        z_mantissa <= norm_mantissa[22:0];
                        z_exponent <= norm_exponent[7:0];
                    end
                    
                    // Handle special cases with priority
                    if (a_nan || b_nan) begin
                        z <= nan_out;
                    end
                    else if ((a_inf || b_inf) && (a_zero || b_zero)) begin
                        z <= nan_out;
                    end
                    else if (a_inf || b_inf) begin
                        z <= inf_out;
                    end
                    else if (a_zero || b_zero) begin
                        z <= zero_out;
                    end
                    else if (&norm_exponent[7:0] || norm_exponent[8]) begin // Overflow
                        z <= inf_out;
                    end
                    else if (norm_exponent == 0) begin // Underflow
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