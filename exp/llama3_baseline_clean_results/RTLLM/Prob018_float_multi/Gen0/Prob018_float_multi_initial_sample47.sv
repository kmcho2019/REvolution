module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [9:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Extract mantissas, exponents, and signs
assign a_mantissa = a[22:0];
assign b_mantissa = b[22:0];
assign a_exponent = a[30:23];
assign b_exponent = b[30:23];
assign a_sign = a[31];
assign b_sign = b[31];

// Initialize counter on reset
always @(posedge clk) begin
    if (rst) begin
        counter <= 3'b000;
    end else begin
        case (counter)
            3'b000: begin
                // Input processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                counter <= 3'b001;
            end
            3'b001: begin
                // Special cases handling
                if ((a_exponent == 10'b1111111111) || (b_exponent == 10'b1111111111)) begin
                    // Handle NaN and infinity cases
                    if ((a_exponent == 10'b1111111111) && (a_mantissa != 24'b0)) begin
                        z <= 32'b1; // NaN
                    end else if ((b_exponent == 10'b1111111111) && (b_mantissa != 24'b0)) begin
                        z <= 32'b1; // NaN
                    end else if ((a_exponent == 10'b1111111111) && (a_mantissa == 24'b0)) begin
                        z <= (a_sign) ? 32'h80000000 : 32'h7f800000; // Infinity
                    end else if ((b_exponent == 10'b1111111111) && (b_mantissa == 24'b0)) begin
                        z <= (b_sign) ? 32'h80000000 : 32'h7f800000; // Infinity
                    end
                    counter <= 3'b111;
                end else begin
                    // Normalize mantissas if needed
                    if (a_mantissa[23] == 1'b0) begin
                        a_mantissa <= {1'b1, a_mantissa[22:0]};
                        a_exponent <= a_exponent - 10'd1;
                    end
                    if (b_mantissa[23] == 1'b0) begin
                        b_mantissa <= {1'b1, b_mantissa[22:0]};
                        b_exponent <= b_exponent - 10'd1;
                    end
                    counter <= 3'b010;
                end
            end
            3'b010: begin
                // Multiply mantissas and adjust exponents
                product <= a_mantissa * b_mantissa;
                z_exponent <= a_exponent + b_exponent + 10'd1;
                z_sign <= a_sign ^ b_sign;
                counter <= 3'b011;
            end
            3'b011: begin
                // Round the result and adjust the exponent
                {guard_bit, round_bit, sticky} <= product[47:45];
                if (guard_bit || round_bit || sticky) begin
                    z_mantissa <= product[46:24] + 1'b1;
                end else begin
                    z_mantissa <= product[46:24];
                end
                if (z_mantissa[23] == 1'b1) begin
                    z_mantissa <= {1'b0, z_mantissa[22:0]};
                    z_exponent <= z_exponent + 10'd1;
                end
                counter <= 3'b100;
            end
            3'b100: begin
                // Generate the final output
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b111;
            end
        endcase
    end
end

endmodule