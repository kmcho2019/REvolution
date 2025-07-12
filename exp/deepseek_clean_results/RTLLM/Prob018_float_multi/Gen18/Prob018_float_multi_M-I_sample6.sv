module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // One-hot state encoding
    localparam IDLE = 4'b0001;
    localparam EXTRACT = 4'b0010;
    localparam MULT1 = 4'b0100;
    localparam MULT2 = 4'b1000;
    localparam NORM = 4'b0001;
    localparam ROUND = 4'b0010;
    localparam OUTPUT = 4'b0100;
    
    reg [3:0] state;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [25:0] product_hi; // Only store upper 26 bits needed for result
    reg [22:0] product_lo; // Lower 23 bits for rounding
    reg guard_bit, round_bit, sticky;
    
    // Gated special case detection
    wire a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;
    assign a_zero = (state == EXTRACT) ? (a[30:0] == 0) : 1'b0;
    assign b_zero = (state == EXTRACT) ? (b[30:0] == 0) : 1'b0;
    assign a_inf = (state == EXTRACT) ? (&a[30:23]) && (a[22:0] == 0) : 1'b0;
    assign b_inf = (state == EXTRACT) ? (&b[30:23]) && (b[22:0] == 0) : 1'b0;
    assign a_nan = (state == EXTRACT) ? (&a[30:23]) && (|a[22:0]) : 1'b0;
    assign b_nan = (state == EXTRACT) ? (&b[30:23]) && (|b[22:0]) : 1'b0;

    // Shared adder for exponent calculation
    wire [8:0] exp_sum = {1'b0, a_exponent} + {1'b0, b_exponent} - 9'd127;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 0;
        end else begin
            case (state)
                IDLE: begin
                    state <= EXTRACT;
                end
                
                EXTRACT: begin  // Input processing
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    
                    // Handle subnormal numbers
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    // Pre-calculate exponent sum
                    z_exponent <= exp_sum[7:0];
                    z_sign <= a_sign ^ b_sign;
                    
                    state <= MULT1;
                end
                
                MULT1: begin  // First stage of multiplication
                    // Multiply lower halves first
                    product_lo <= a_mantissa[11:0] * b_mantissa[11:0];
                    state <= MULT2;
                end
                
                MULT2: begin  // Second stage of multiplication
                    // Multiply upper halves and sum partial products
                    product_hi <= (a_mantissa[23:12] * b_mantissa[23:12]) + 
                                 (a_mantissa[23:12] * b_mantissa[11:0] >> 12) +
                                 (b_mantissa[23:12] * a_mantissa[11:0] >> 12);
                    state <= NORM;
                end
                
                NORM: begin  // Normalization
                    // Combine multiplication results
                    if (product_hi[25]) begin
                        z_mantissa <= product_hi[25:2];
                        z_exponent <= z_exponent + 1;
                    end else begin
                        z_mantissa <= product_hi[24:1];
                    end
                    
                    // Capture rounding bits
                    guard_bit <= product_hi[0];
                    round_bit <= product_lo[22];
                    sticky <= |product_lo[21:0];
                    
                    state <= ROUND;
                end
                
                ROUND: begin  // Rounding
                    // Round to nearest even
                    if (guard_bit && (round_bit || sticky || z_mantissa[0])) begin
                        {z_exponent, z_mantissa} <= z_mantissa + 1;
                    end
                    state <= OUTPUT;
                end
                
                OUTPUT: begin  // Output generation
                    // Handle special cases first
                    if (a_nan || b_nan) begin
                        z <= 32'h7FC00000;  // NaN
                    end else if (a_inf || b_inf) begin
                        z <= (a_zero || b_zero) ? 32'h7FC00000 : {z_sign, 8'hFF, 23'b0};
                    end else if (a_zero || b_zero) begin
                        z <= {z_sign, 31'b0};
                    end else if (exp_sum[8] || (z_exponent[7:0] == 8'hFF)) begin
                        z <= {z_sign, 8'hFF, 23'b0};  // Overflow
                    end else if (~|z_exponent[7:0]) begin
                        z <= {z_sign, 31'b0};  // Underflow
                    end else begin
                        z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                    end
                    
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule