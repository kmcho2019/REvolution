module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // State definitions
    localparam IDLE = 2'd0;
    localparam PROCESS = 2'd1;
    localparam NORM_ROUND = 2'd2;
    
    reg [1:0] state;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [8:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;
    
    // Continuous assignments for special case detection
    wire a_is_zero = (a[30:0] == 0);
    wire b_is_zero = (b[30:0] == 0);
    wire a_is_denorm = (a[30:23] == 0) && (|a[22:0]);
    wire b_is_denorm = (b[30:23] == 0) && (|b[22:0]);
    wire a_is_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_is_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_is_nan = (&a[30:23]) && (|a[22:0]);
    wire b_is_nan = (&b[30:23]) && (|b[22:0]);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 0;
        end else begin
            case (state)
                IDLE: begin
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    
                    // Handle denormal numbers
                    a_mantissa <= a_is_denorm ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= b_is_denorm ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
                    
                    state <= PROCESS;
                end
                
                PROCESS: begin
                    // Multiply mantissas
                    product <= a_mantissa * b_mantissa;
                    
                    // Calculate exponent sum with bias adjustment
                    z_exponent <= (a_is_denorm ? 9'd1 : a_exponent) + 
                                 (b_is_denorm ? 9'd1 : b_exponent) - 9'd127;
                    
                    // Calculate sign
                    z_sign <= a_sign ^ b_sign;
                    
                    state <= NORM_ROUND;
                end
                
                NORM_ROUND: begin
                    // Handle special cases
                    if (a_is_nan || b_is_nan) begin
                        z <= {1'b0, 8'hFF, 1'b1, 22'h0}; // Canonical NaN
                    end else if ((a_is_zero && b_is_inf) || (a_is_inf && b_is_zero)) begin
                        z <= {z_sign, 8'hFF, 1'b1, 22'h0}; // NaN
                    end else if (a_is_inf || b_is_inf) begin
                        z <= {z_sign, 8'hFF, 23'h0}; // Infinity
                    end else if (a_is_zero || b_is_zero) begin
                        z <= {z_sign, 31'h0}; // Zero
                    end else begin
                        // Normalization
                        if (!product[47]) begin
                            product <= product << 1;
                            z_exponent <= z_exponent - 1;
                        end
                        
                        // Rounding calculation
                        wire round_bit = product[23];
                        wire sticky_bit = |product[22:0];
                        wire lsb = product[24];
                        wire do_round = round_bit & (sticky_bit | lsb);
                        
                        z_mantissa <= product[46:24] + do_round;
                        
                        // Handle mantissa overflow after rounding
                        if (z_mantissa[23]) begin
                            z_mantissa <= z_mantissa >> 1;
                            z_exponent <= z_exponent + 1;
                        end
                        
                        // Check exponent range
                        if (z_exponent[8] || (&z_exponent[7:0])) begin // Overflow
                            z <= {z_sign, 8'hFF, 23'h0}; // Infinity
                        end else if (z_exponent[7:0] == 0) begin // Underflow
                            z <= {z_sign, 31'h0}; // Zero
                        end else begin
                            z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                        end
                    end
                    
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule