module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Simplified state encoding
    localparam IDLE  = 2'b00;
    localparam CALC  = 2'b01;
    localparam OUTPUT = 2'b10;

    reg [1:0] state;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;
    
    // Special case detection
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = &a[30:23] && |a[22:0];
    wire b_nan = &b[30:23] && |b[22:0];
    
    wire any_nan = a_nan || b_nan;
    wire any_inf = a_inf || b_inf;
    wire any_zero = a_zero || b_zero;
    wire inf_times_zero = (a_inf && b_zero) || (a_zero && b_inf);
    
    // Sign calculation
    wire sign_result = a_sign ^ b_sign;
    
    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {sign_result, 8'hFF, 23'b0};
    wire [31:0] zero_out = {sign_result, 31'b0};

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
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    state <= CALC;
                end
                
                CALC: begin
                    // Single-cycle multiplication
                    product <= a_mantissa * b_mantissa;
                    
                    // Calculate exponent (with bias adjustment)
                    z_exponent <= a_exponent + b_exponent - 8'd127;
                    
                    state <= OUTPUT;
                end
                
                OUTPUT: begin
                    // Handle special cases first
                    if (any_nan || inf_times_zero) begin
                        z <= nan_out;
                    end else if (any_inf) begin
                        z <= inf_out;
                    end else if (any_zero) begin
                        z <= zero_out;
                    end else begin
                        // Normalize and round
                        if (product[47]) begin
                            z_mantissa <= product[47:24] + (product[23] & (product[22] | |product[21:0]));
                            z_exponent <= z_exponent + 1;
                        end else begin
                            z_mantissa <= product[46:23] + (product[22] & (product[21] | |product[20:0]));
                        end
                        
                        // Check for overflow/underflow
                        if (&z_exponent || z_exponent[7] && ~&z_exponent[6:0]) begin // Overflow
                            z <= inf_out;
                        end else if (z_exponent == 0) begin // Underflow
                            z <= zero_out;
                        end else begin
                            z <= {sign_result, z_exponent, z_mantissa[22:0]};
                        end
                    end
                    
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule