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
    localparam ROUND = 2;
    localparam OUTPUT = 3;

    reg [1:0] state;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;
    reg guard_bit;
    
    // Special case flags
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    
    // Early output for special cases
    wire [31:0] special_out = 
        (a_nan || b_nan) ? 32'h7FC00000 :
        ((a_inf || b_inf) && (a_zero || b_zero)) ? 32'h7FC00000 :
        (a_inf || b_inf) ? {a_sign ^ b_sign, 8'hFF, 23'b0} :
        (a_zero || b_zero) ? {a_sign ^ b_sign, 31'b0} : 32'h0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= EXTRACT;
            z <= 0;
        end else begin
            case (state)
                EXTRACT: begin
                    // Handle special cases immediately
                    if (a_nan || b_nan || (a_inf && b_zero) || (b_inf && a_zero) || 
                        a_inf || b_inf || a_zero || b_zero) begin
                        z <= special_out;
                        state <= EXTRACT;
                    end else begin
                        // Extract components
                        a_sign <= a[31];
                        b_sign <= b[31];
                        a_exponent <= a[30:23];
                        b_exponent <= b[30:23];
                        a_mantissa <= {1'b1, a[22:0]};
                        b_mantissa <= {1'b1, b[22:0]};
                        state <= MULTIPLY;
                    end
                end
                
                MULTIPLY: begin
                    // Multiply and normalize in same cycle
                    product = a_mantissa * b_mantissa;
                    
                    // Normalize
                    if (product[47]) begin
                        z_mantissa <= product[47:25]; // Keep 24 bits (1 implicit + 23 explicit)
                        z_exponent <= a_exponent + b_exponent - 126; // 127 bias * 2 - 127 + 1
                    end else begin
                        z_mantissa <= product[46:24];
                        z_exponent <= a_exponent + b_exponent - 127;
                    end
                    
                    guard_bit <= product[24];
                    z_sign <= a_sign ^ b_sign;
                    state <= ROUND;
                end
                
                ROUND: begin
                    // Simple rounding (round to nearest even)
                    if (guard_bit && (z_mantissa[0] || product[23])) begin
                        z_mantissa <= z_mantissa + 1;
                        if (z_mantissa == 24'hFFFFFF) begin // Handle mantissa overflow
                            z_exponent <= z_exponent + 1;
                        end
                    end
                    state <= OUTPUT;
                end
                
                OUTPUT: begin
                    // Check for overflow/underflow
                    if (z_exponent[7] && z_exponent != 8'hFF) begin // Underflow
                        z <= {z_sign, 31'b0};
                    end else if (&z_exponent) begin // Overflow
                        z <= {z_sign, 8'hFF, 23'b0};
                    end else begin
                        z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                    end
                    state <= EXTRACT;
                end
            endcase
        end
    end

endmodule