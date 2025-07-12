module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg [23:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg a_sign, b_sign;
    
    reg [47:0] product;
    reg [7:0] z_exponent;
    reg z_sign;
    reg guard_bit;
    
    // Special case flags
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            // Stage 1: Input processing and multiplication
            a_sign <= a[31];
            b_sign <= b[31];
            a_exponent <= a[30:23];
            b_exponent <= b[30:23];
            a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
            b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
            product <= a_mantissa * b_mantissa;
            
            // Stage 2: Exponent and sign calculation
            z_exponent <= a_exponent + b_exponent - 8'd127;
            z_sign <= a_sign ^ b_sign;
            guard_bit <= product[22];
            
            // Stage 3: Normalization and output
            if (a_nan || b_nan) begin
                z <= 32'h7FC00000;  // NaN
            end else if (a_inf || b_inf) begin
                z <= (a_zero || b_zero) ? 32'h7FC00000 : {z_sign, 8'hFF, 23'b0};
            end else if (a_zero || b_zero) begin
                z <= {z_sign, 31'b0};
            end else begin
                // Normalize
                if (product[47]) begin
                    z_exponent <= z_exponent + 1;
                    product <= product >> 1;
                end
                
                // Round (simple round-to-nearest)
                if (guard_bit && product[23]) begin
                    product <= product + 24'h1;
                end
                
                // Check for overflow/underflow
                if (z_exponent[7] && !z_exponent[8]) begin  // Underflow
                    z <= {z_sign, 31'b0};
                end else if (&z_exponent[7:0]) begin  // Overflow
                    z <= {z_sign, 8'hFF, 23'b0};
                end else begin
                    z <= {z_sign, z_exponent[7:0], product[46:24]};
                end
            end
        end
    end

endmodule