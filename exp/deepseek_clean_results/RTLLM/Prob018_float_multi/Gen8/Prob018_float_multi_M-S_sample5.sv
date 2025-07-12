module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Internal registers
    reg [23:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg a_sign, b_sign;
    reg [47:0] product;
    
    // Special case detection
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
            // Stage 1: Extract components
            a_sign <= a[31];
            b_sign <= b[31];
            a_exponent <= a[30:23];
            b_exponent <= b[30:23];
            a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
            b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
            
            // Stage 2: Multiply and normalize
            product <= a_mantissa * b_mantissa;
            
            // Stage 3: Output generation
            if (a_nan || b_nan) begin
                z <= 32'h7FC00000; // NaN
            end else if ((a_inf || b_inf) && (a_zero || b_zero)) begin
                z <= 32'h7FC00000; // NaN
            end else if (a_inf || b_inf) begin
                z <= {a_sign ^ b_sign, 8'hFF, 23'b0}; // Inf
            end else if (a_zero || b_zero) begin
                z <= {a_sign ^ b_sign, 31'b0}; // Zero
            end else begin
                // Normal case - normalize and round
                reg [23:0] mantissa;
                reg [7:0] exponent;
                reg sign = a_sign ^ b_sign;
                
                // Normalize
                if (product[47]) begin
                    mantissa = product[47:24];
                    exponent = a_exponent + b_exponent - 126; // -127 +1 for shift
                end else begin
                    mantissa = product[46:23];
                    exponent = a_exponent + b_exponent - 127;
                end
                
                // Round (using round-to-nearest-even)
                if (product[22] && (product[21] || |product[20:0] || mantissa[0])) begin
                    mantissa = mantissa + 1;
                    if (mantissa[23]) begin // Overflow
                        mantissa = {1'b1, 23'b0};
                        exponent = exponent + 1;
                    end
                end
                
                // Check for overflow/underflow
                if (exponent[7] || &exponent[6:0]) begin // Overflow
                    z <= {sign, 8'hFF, 23'b0};
                end else if (exponent == 0) begin // Underflow
                    z <= {sign, 31'b0};
                end else begin
                    z <= {sign, exponent[6:0], mantissa[22:0]};
                end
            end
        end
    end

endmodule