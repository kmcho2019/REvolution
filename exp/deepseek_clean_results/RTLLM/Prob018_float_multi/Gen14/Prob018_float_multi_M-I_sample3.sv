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
    wire a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;
    assign a_zero = (state == IDLE) && (a[30:0] == 0);
    assign b_zero = (state == IDLE) && (b[30:0] == 0);
    assign a_inf = (state == IDLE) && (&a[30:23]) && (a[22:0] == 0);
    assign b_inf = (state == IDLE) && (&b[30:23]) && (b[22:0] == 0);
    assign a_nan = (state == IDLE) && (&a[30:23]) && (|a[22:0]);
    assign b_nan = (state == IDLE) && (&b[30:23]) && (|b[22:0]);

    // Split multiplier implementation
    wire [23:0] a_hi = a_mantissa[23:12];
    wire [23:0] a_lo = {12'b0, a_mantissa[11:0]};
    wire [23:0] b_hi = b_mantissa[23:12];
    wire [23:0] b_lo = {12'b0, b_mantissa[11:0]};
    
    reg [35:0] product_hi, product_mid, product_lo;
    reg [47:0] product_sum;

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
                    
                    // Handle subnormal numbers
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    // Pre-calculate exponent with bias
                    z_exponent <= a_exponent + b_exponent - 8'd127;
                    z_sign <= a_sign ^ b_sign;
                    
                    state <= MULT;
                end
                
                MULT: begin  // Pipelined multiplication
                    // Partial products
                    product_hi <= a_hi * b_hi;
                    product_mid <= (a_hi * b_lo) + (a_lo * b_hi);
                    product_lo <= a_lo * b_lo;
                    
                    state <= NORM;
                end
                
                NORM: begin  // Normalization and rounding
                    // Combine partial products
                    product_sum <= (product_hi << 24) + (product_mid << 12) + product_lo;
                    
                    // Normalize and extract mantissa
                    if (product_sum[47]) begin
                        z_mantissa <= product_sum[47:24];
                        z_exponent <= z_exponent + 1;
                    end else begin
                        z_mantissa <= product_sum[46:23];
                    end
                    
                    // Rounding bits
                    guard_bit <= product_sum[22];
                    sticky <= |product_sum[21:0];
                    
                    // Round to nearest even
                    if (guard_bit && (sticky || z_mantissa[0])) begin
                        {z_exponent, z_mantissa} <= z_mantissa + 1;
                    end
                    
                    // Output generation
                    if (a_nan || b_nan) begin
                        z <= 32'h7FC00000;  // NaN
                    end else if (a_inf || b_inf) begin
                        z <= (a_zero || b_zero) ? 32'h7FC00000 : {z_sign, 8'hFF, 23'b0};
                    end else if (a_zero || b_zero) begin
                        z <= {z_sign, 31'b0};
                    end else if (&z_exponent || (z_exponent == 8'hFF)) begin
                        z <= {z_sign, 8'hFF, 23'b0};  // Overflow
                    end else if (~|z_exponent) begin
                        z <= {z_sign, 31'b0};  // Underflow
                    end else begin
                        z <= {z_sign, z_exponent, z_mantissa[22:0]};
                    end
                    
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule