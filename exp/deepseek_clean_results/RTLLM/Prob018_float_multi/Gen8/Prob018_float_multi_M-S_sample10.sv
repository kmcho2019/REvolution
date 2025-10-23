module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg state;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [23:0] product;
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            z <= 0;
        end else begin
            case (state)
                0: begin  // Input processing and initial computation
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};

                    // Start multiplication and exponent calculation
                    product <= a_mantissa * b_mantissa[23:12];  // Partial product
                    z_exponent <= a_exponent + b_exponent - 8'd127;
                    z_sign <= a_sign ^ b_sign;
                    
                    state <= 1;
                end
                
                1: begin  // Final computation and output
                    // Complete multiplication and normalize
                    product <= product + (a_mantissa * b_mantissa[11:0]);
                    
                    if (product[23]) begin
                        z_mantissa <= product[23:1];
                        z_exponent <= z_exponent + 1;
                    end else begin
                        z_mantissa <= product[22:0];
                    end

                    // Handle all special cases and output
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
                    
                    state <= 0;
                end
            endcase
        end
    end

endmodule