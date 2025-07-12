module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stages
    localparam S_EXTRACT = 0;
    localparam S_COMPUTE = 1;
    localparam S_OUTPUT = 2;

    reg [1:0] state;
    reg [23:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg a_sign, b_sign;
    
    // Special case detection
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_EXTRACT;
            z <= 0;
        end else begin
            case (state)
                S_EXTRACT: begin
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    state <= S_COMPUTE;
                end
                
                S_COMPUTE: begin
                    // Compute product and exponent
                    reg [47:0] product = a_mantissa * b_mantissa;
                    reg [8:0] exp_sum = {1'b0, a_exponent} + {1'b0, b_exponent};
                    reg [8:0] exp_biased = exp_sum - 9'd127;
                    
                    // Normalize
                    reg product_msb = product[47];
                    reg [23:0] mantissa = product_msb ? product[47:24] : product[46:23];
                    reg [8:0] exponent = product_msb ? (exp_biased + 1) : exp_biased;
                    
                    // Rounding
                    reg guard = product_msb ? product[23] : product[22];
                    reg round = product_msb ? product[22] : product[21];
                    reg sticky = product_msb ? (|product[21:0]) : (|product[20:0]);
                    
                    if (guard && (round || sticky || mantissa[0])) begin
                        mantissa = mantissa + 1;
                        if (mantissa[24]) begin // Handle carry
                            mantissa = {1'b1, 23'b0};
                            exponent = exponent + 1;
                        end
                    end
                    
                    // Prepare output
                    reg sign = a_sign ^ b_sign;
                    
                    // Handle special cases with priority
                    if (a_nan || b_nan) begin
                        z <= 32'h7FC00000;
                    end
                    else if ((a_inf || b_inf) && (a_zero || b_zero)) begin
                        z <= 32'h7FC00000;
                    end
                    else if (a_inf || b_inf) begin
                        z <= {sign, 8'hFF, 23'b0};
                    end
                    else if (a_zero || b_zero) begin
                        z <= {sign, 31'b0};
                    end
                    else if (&exponent[7:0] || exponent[8]) begin // Overflow
                        z <= {sign, 8'hFF, 23'b0};
                    end
                    else if (exponent == 0) begin // Underflow
                        z <= {sign, 31'b0};
                    end
                    else begin
                        z <= {sign, exponent[7:0], mantissa[22:0]};
                    end
                    
                    state <= S_EXTRACT;
                end
            endcase
        end
    end

endmodule