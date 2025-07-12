module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [1:0] state;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [8:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;
    reg guard_bit, sticky;
    wire a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;

    // Special case detection (combinational)
    assign a_zero = (a[30:0] == 0);
    assign b_zero = (b[30:0] == 0);
    assign a_inf = (&a[30:23]) && (a[22:0] == 0);
    assign b_inf = (&b[30:23]) && (b[22:0] == 0);
    assign a_nan = (&a[30:23]) && (|a[22:0]);
    assign b_nan = (&b[30:23]) && (|b[22:0]);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            z <= 0;
        end else begin
            case (state)
                0: begin  // Input processing
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    state <= 1;
                end
                
                1: begin  // Multiplication and exponent handling
                    // Multiply mantissas
                    product <= a_mantissa * b_mantissa;
                    
                    // Calculate exponent (with bias adjustment)
                    z_exponent <= {1'b0, a_exponent} + {1'b0, b_exponent} - 9'd127;
                    z_sign <= a_sign ^ b_sign;
                    
                    state <= 2;
                end
                
                2: begin  // Normalization and rounding
                    // Normalize
                    if (product[47]) begin
                        z_mantissa <= product[47:24];
                        z_exponent <= z_exponent + 1;
                    end else begin
                        z_mantissa <= product[46:23];
                    end
                    
                    // Rounding bits
                    guard_bit <= product[22];
                    sticky <= |product[21:0];
                    
                    // Round if needed (round to nearest even)
                    if (guard_bit && (sticky || z_mantissa[0])) begin
                        {z_exponent, z_mantissa} <= z_mantissa + 1;
                    end
                    
                    state <= 3;
                end
                
                3: begin  // Output generation
                    // Handle special cases first
                    if (a_nan || b_nan) begin
                        z <= 32'h7FC00000;  // NaN
                    end else if (a_inf || b_inf) begin
                        z <= (a_zero || b_zero) ? 32'h7FC00000 : {z_sign, 8'hFF, 23'b0};
                    end else if (a_zero || b_zero) begin
                        z <= {z_sign, 31'b0};
                    end else if (z_exponent[8] || (z_exponent[7:0] == 8'hFF)) begin
                        z <= {z_sign, 8'hFF, 23'b0};  // Overflow
                    end else if (~|z_exponent[7:0]) begin
                        z <= {z_sign, 31'b0};  // Underflow
                    end else begin
                        z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                    end
                    
                    state <= 0;
                end
            endcase
        end
    end

endmodule