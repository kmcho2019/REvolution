module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // One-hot state encoding
    localparam IDLE = 3'b001;
    localparam MULT = 3'b010;
    localparam NORM = 3'b100;
    
    reg [2:0] state;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;
    reg guard_bit, sticky;
    
    // Gated special case detection
    wire a_zero = (state == IDLE) && (a[30:0] == 0);
    wire b_zero = (state == IDLE) && (b[30:0] == 0);
    wire a_inf = (state == IDLE) && (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (state == IDLE) && (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (state == IDLE) && (&a[30:23]) && (|a[22:0]);
    wire b_nan = (state == IDLE) && (&b[30:23]) && (|b[22:0]);

    // Split multiplier outputs
    wire [35:0] product_lo = a_mantissa[11:0] * b_mantissa;
    wire [35:0] product_hi = a_mantissa[23:12] * b_mantissa;
    
    // Pre-calculated exponent bias
    wire [8:0] exp_sum = {1'b0, a_exponent} + {1'b0, b_exponent} - 9'd127;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 0;
        end else begin
            case (state)
                IDLE: begin  // Input processing
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    state <= MULT;
                end
                
                MULT: begin  // Pipelined multiplication
                    // Combine partial products
                    product <= (product_hi << 12) + product_lo;
                    z_exponent <= exp_sum[7:0];
                    z_sign <= a_sign ^ b_sign;
                    
                    state <= NORM;
                end
                
                NORM: begin  // Normalization and rounding
                    // Normalize with shared adder
                    if (product[47]) begin
                        {z_exponent, z_mantissa} <= {z_exponent + 1, product[47:24]};
                    end else begin
                        {z_exponent, z_mantissa} <= {z_exponent, product[46:23]};
                    end
                    
                    // Rounding bits
                    guard_bit <= product[22];
                    sticky <= |product[21:0];
                    
                    // Final output generation
                    if (a_nan || b_nan) begin
                        z <= 32'h7FC00000;  // NaN
                    end else if (a_inf || b_inf) begin
                        z <= (a_zero || b_zero) ? 32'h7FC00000 : {z_sign, 8'hFF, 23'b0};
                    end else if (a_zero || b_zero) begin
                        z <= {z_sign, 31'b0};
                    end else if (exp_sum[8] || (&z_exponent)) begin  // Overflow
                        z <= {z_sign, 8'hFF, 23'b0};
                    end else if (~|z_exponent) begin  // Underflow
                        z <= {z_sign, 31'b0};
                    end else begin
                        // Round to nearest even
                        if (guard_bit && (sticky || z_mantissa[0])) begin
                            {z_exponent, z_mantissa} <= {z_exponent, z_mantissa} + 1;
                        end
                        z <= {z_sign, z_exponent, z_mantissa[22:0]};
                    end
                    
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule