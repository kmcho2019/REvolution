module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [1:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0] a_exponent, b_exponent, z_exponent;
    reg [47:0] product;
    reg guard_bit, round_bit, sticky;
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    wire z_sign = a[31] ^ b[31];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 0;
        end else begin
            case (counter)
                0: begin  // Cycle 1: Input processing and multiplication
                    // Extract components
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    // Special cases take priority
                    if (a_nan || b_nan) begin
                        z <= 32'h7FC00000;
                        counter <= 0;
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        z <= 32'h7FC00000;
                        counter <= 0;
                    end else if (a_inf || b_inf) begin
                        z <= {z_sign, 8'hFF, 23'b0};
                        counter <= 0;
                    end else if (a_zero || b_zero) begin
                        z <= {z_sign, 31'b0};
                        counter <= 0;
                    end else begin
                        product <= a_mantissa * b_mantissa;
                        z_exponent <= a_exponent + b_exponent - 8'd127;
                        counter <= counter + 1;
                    end
                end
                
                1: begin  // Cycle 2: Normalization and rounding
                    // Normalize
                    if (product[47]) begin
                        z_mantissa <= product[47:24];
                        z_exponent <= z_exponent + 1;
                    end else begin
                        z_mantissa <= product[46:23];
                    end
                    
                    // Rounding bits
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    sticky <= |product[20:0];
                    
                    counter <= counter + 1;
                end
                
                2: begin  // Cycle 3: Final rounding and output
                    // Round if needed
                    if (guard_bit && (round_bit || sticky || z_mantissa[0])) begin
                        {z_mantissa, z_exponent} <= z_mantissa + 1;
                        if (&z_mantissa) begin  // Handle overflow
                            z_mantissa <= 24'h800000;
                            z_exponent <= z_exponent + 1;
                        end
                    end
                    
                    // Check for overflow/underflow
                    if (z_exponent[7] && !z_exponent[8]) begin  // Overflow
                        z <= {z_sign, 8'hFF, 23'b0};
                    end else if (z_exponent == 0) begin  // Underflow
                        z <= {z_sign, 31'b0};
                    end else begin
                        z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                    end
                    
                    counter <= 0;
                end
            endcase
        end
    end

endmodule