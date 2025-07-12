module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // State encoding
    localparam EXTRACT = 0;
    localparam MULTIPLY = 1;
    localparam NORMALIZE = 2;
    localparam ROUND = 3;
    localparam OUTPUT = 4;

    reg [2:0] state;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [8:0] a_exponent, b_exponent, z_exponent; // 9 bits (8 + overflow)
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;  // 24x24 = 48 bits
    reg guard_bit, round_bit, sticky;
    
    // Special case flags (registered for timing)
    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;
    
    // Combinational signals
    wire [8:0] exp_sum = a_exponent + b_exponent;
    wire [8:0] exp_biased = exp_sum - 9'd127;
    wire sign_result = a_sign ^ b_sign;
    wire [23:0] norm_mantissa = product[47] ? product[47:24] : product[46:23];
    wire [8:0] norm_exponent = product[47] ? (exp_biased + 1) : exp_biased;
    wire round_inc = guard_bit && (round_bit || sticky || z_mantissa[0]);
    
    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {z_sign, 8'hFF, 23'b0};
    wire [31:0] zero_out = {z_sign, 31'b0};
    wire [31:0] normal_out = {z_sign, z_exponent[7:0], z_mantissa[22:0]};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= EXTRACT;
            z <= 0;
        end else begin
            case (state)
                EXTRACT: begin
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= {1'b0, a[30:23]};
                    b_exponent <= {1'b0, b[30:23]};
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    // Special case detection (registered for timing)
                    a_zero <= (a[30:0] == 0);
                    b_zero <= (b[30:0] == 0);
                    a_inf <= (&a[30:23]) && (a[22:0] == 0);
                    b_inf <= (&b[30:23]) && (b[22:0] == 0);
                    a_nan <= (&a[30:23]) && (|a[22:0]);
                    b_nan <= (&b[30:23]) && (|b[22:0]);
                    
                    state <= MULTIPLY;
                end
                
                MULTIPLY: begin
                    // Perform multiplication with registered output
                    product <= a_mantissa * b_mantissa;
                    z_exponent <= exp_biased;
                    z_sign <= sign_result;
                    
                    // Early sticky bit calculation
                    sticky <= |b_mantissa[11:0]; // Approximate for timing
                    
                    state <= NORMALIZE;
                end
                
                NORMALIZE: begin
                    // Normalize result
                    z_mantissa <= norm_mantissa;
                    z_exponent <= norm_exponent;
                    
                    // Final sticky bit calculation
                    sticky <= sticky | (product[47] ? |product[23:0] : |product[22:0]);
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    
                    state <= ROUND;
                end
                
                ROUND: begin
                    // Apply rounding with overflow check
                    if (round_inc) begin
                        {z_exponent[0], z_mantissa} <= z_mantissa + 1;
                        if (&z_mantissa) begin // Mantissa overflow
                            z_mantissa <= {1'b1, 23'b0};
                            z_exponent <= z_exponent + 1;
                        end
                    end
                    
                    state <= OUTPUT;
                end
                
                OUTPUT: begin
                    // Priority-based output selection
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
                    else if (z_exponent[8] || (&z_exponent[7:0])) begin // Overflow
                        z <= inf_out;
                    end
                    else if (z_exponent == 0) begin // Underflow
                        z <= zero_out;
                    end
                    else begin
                        z <= normal_out;
                    end
                    
                    state <= EXTRACT;
                end
            endcase
        end
    end

endmodule