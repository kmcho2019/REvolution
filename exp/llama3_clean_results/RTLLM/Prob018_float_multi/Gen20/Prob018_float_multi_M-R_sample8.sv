module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] state; // State variable for FSM
reg a_sign, b_sign; // Sign bits of inputs
reg [8:0] a_exponent, b_exponent; // Exponents of inputs
reg [23:0] a_mantissa, b_mantissa; // Mantissas of inputs
reg [49:0] product_mantissa; // Mantissa of product
reg [8:0] product_exponent; // Exponent of product
reg product_sign; // Sign bit of product
reg [23:0] normalized_mantissa; // Normalized mantissa
reg [8:0] normalized_exponent; // Normalized exponent
reg [23:0] rounded_mantissa; // Rounded mantissa
reg [8:0] rounded_exponent; // Rounded exponent
reg guard_bit, round_bit, sticky; // Rounding control bits

// Assign statements
assign a_sign = a[31];
assign a_exponent = a[30:23];
assign a_mantissa = a[22:0];
assign b_sign = b[31];
assign b_exponent = b[30:23];
assign b_mantissa = b[22:0];

// Special case handling
always @(*) begin
    if (a_exponent == 9'd255 || b_exponent == 9'd255) begin
        if (a_exponent == 9'd255 && a_mantissa != 0) begin // NaN
            z = {1'b1, 8'd255, 23'd0};
        end else if (b_exponent == 9'd255 && b_mantissa != 0) begin // NaN
            z = {1'b1, 8'd255, 23'd0};
        end else if (a_exponent == 9'd255) begin // Infinity
            z = {a_sign, 8'd255, 23'd0};
        end else begin // Infinity
            z = {b_sign, 8'd255, 23'd0};
        end
    end else begin
        // Proceed with multiplication and rounding
    end
end

// Multiplication and normalization
always @(posedge clk) begin
    if (rst) begin
        state <= 3'b000;
    end else begin
        case (state)
            3'b000: begin
                product_exponent <= a_exponent + b_exponent - 9'd127;
                product_mantissa <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                product_sign <= a_sign ^ b_sign;
                state <= 3'b001;
            end
            3'b001: begin
                if (product_mantissa[49]) begin
                    normalized_mantissa <= product_mantissa[48:26];
                    normalized_exponent <= product_exponent + 1;
                end else begin
                    normalized_mantissa <= product_mantissa[47:25];
                    normalized_exponent <= product_exponent;
                end
                state <= 3'b010;
            end
            3'b010: begin
                // Rounding logic implementation
                guard_bit <= normalized_mantissa[0];
                round_bit <= normalized_mantissa[1];
                sticky <= |normalized_mantissa[23:2];
                if (guard_bit && (round_bit || sticky)) begin
                    rounded_mantissa <= normalized_mantissa[23:1] + 1;
                    rounded_exponent <= normalized_exponent;
                end else begin
                    rounded_mantissa <= normalized_mantissa[23:1];
                    rounded_exponent <= normalized_exponent;
                end
                state <= 3'b011;
            end
            3'b011: begin
                z <= {product_sign, rounded_exponent, rounded_mantissa};
                state <= 3'b000;
            end
            default: begin
                state <= 3'b000;
            end
        endcase
    end
end

endmodule