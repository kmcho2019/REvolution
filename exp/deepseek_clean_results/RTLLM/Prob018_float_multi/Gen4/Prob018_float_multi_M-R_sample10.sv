module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // State encoding
    localparam IDLE = 0;
    localparam EXTRACT = 1;
    localparam MULTIPLY = 2;
    localparam NORMALIZE = 3;
    localparam ROUND = 4;
    localparam OUTPUT = 5;

    reg [2:0] state;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [9:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;
    reg guard_bit, round_bit, sticky;
    
    // Special case flags
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    
    // Intermediate signals
    wire [9:0] exp_sum = a_exponent + b_exponent;
    wire [9:0] exp_biased = exp_sum - 10'd127;
    wire sign_result = a_sign ^ b_sign;
    
    // Rounding increment
    wire round_inc = guard_bit && (round_bit || sticky || z_mantissa[0]);
    
    // Normalized mantissa and exponent
    wire [23:0] norm_mantissa = product[47] ? product[47:24] : product[46:23];
    wire [9:0] norm_exponent = product[47] ? (exp_biased + 1) : exp_biased;
    
    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {sign_result, 8'hFF, 23'b0};
    wire [31:0] zero_out = {sign_result, 31'b0};
    wire [31:0] normal_out = {sign_result, z_exponent[7:0], z_mantissa[22:0]};
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 0;
        end else begin
            case (state)
                IDLE: begin
                    state <= EXTRACT;
                end
                
                EXTRACT: begin
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= {2'b0, a[30:23]};
                    b_exponent <= {2'b0, b[30:23]};
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    state <= MULTIPLY;
                end
                
                MULTIPLY: begin
                    // Perform multiplication
                    product <= a_mantissa * b_mantissa;
                    z_exponent <= exp_biased;
                    z_sign <= sign_result;
                    
                    state <= NORMALIZE;
                end
                
                NORMALIZE: begin
                    // Normalize result
                    z_mantissa <= norm_mantissa;
                    z_exponent <= norm_exponent;
                    
                    // Extract rounding bits
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    sticky <= |product[20:0];
                    
                    state <= ROUND;
                end
                
                ROUND: begin
                    // Apply rounding
                    if (round_inc) begin
                        z_mantissa <= z_mantissa + 1;
                        if (&z_mantissa) begin // Mantissa overflow
                            z_mantissa <= {1'b1, 23'b0};
                            z_exponent <= z_exponent + 1;
                        end
                    end
                    
                    state <= OUTPUT;
                end
                
                OUTPUT: begin
                    // Handle special cases with priority
                    if (a_nan || b_nan) begin
                        z <= nan_out;
                    end else if ((a_inf || b_inf) && (a_zero || b_zero)) begin
                        z <= nan_out;
                    end else if (a_inf || b_inf) begin
                        z <= inf_out;
                    end else if (a_zero || b_zero) begin
                        z <= zero_out;
                    end else if (z_exponent[9] || (&z_exponent[7:0])) begin // Overflow
                        z <= inf_out;
                    end else if (z_exponent[8] || (z_exponent == 0)) begin // Underflow
                        z <= zero_out;
                    end else begin
                        z <= normal_out;
                    end
                    
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule