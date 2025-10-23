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
    localparam S_NORMALIZE = 2;
    localparam S_OUTPUT = 3;

    reg [1:0] state;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [8:0] a_exponent, b_exponent, z_exponent;  // 9 bits (8 + overflow)
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;  // 24x24 = 48 bits
    reg guard_bit, round_bit, sticky;
    
    // Special case detection (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    
    // Intermediate calculations
    wire [8:0] exp_sum = a_exponent + b_exponent;
    wire [8:0] exp_biased = exp_sum - 9'd127;
    wire sign_result = a_sign ^ b_sign;
    
    // Normalization
    wire product_msb = product[47];
    wire [23:0] norm_mantissa = product_msb ? product[47:24] : product[46:23];
    wire [8:0] norm_exponent = product_msb ? (exp_biased + 1) : exp_biased;
    
    // Rounding
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
                    // Multiply mantissas and calculate exponent
                    product <= a_mantissa * b_mantissa;
                    z_exponent <= exp_biased;
                    z_sign <= sign_result;
                    
                    state <= S_NORMALIZE;
                end
                
                S_NORMALIZE: begin
                    // Normalize and store results
                    z_mantissa <= norm_mantissa;
                    z_exponent <= norm_exponent;
                    
                    // Extract rounding bits
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    sticky <= |product[20:0];
                    
                    // Apply rounding
                    if (round_inc) begin
                        z_mantissa <= z_mantissa + 1;
                        if (&z_mantissa) begin // Mantissa overflow
                            z_mantissa <= {1'b1, 23'b0};
                            z_exponent <= z_exponent + 1;
                        end
                    end
                    
                    state <= S_OUTPUT;
                end
                
                S_OUTPUT: begin
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
                    else if (&z_exponent[7:0] || z_exponent[8]) begin // Overflow
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