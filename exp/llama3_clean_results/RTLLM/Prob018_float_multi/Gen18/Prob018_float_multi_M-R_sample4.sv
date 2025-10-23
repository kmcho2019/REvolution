module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] state; // State machine for the multiplication process
reg a_sign, b_sign; // Sign bits of inputs
reg [7:0] a_exponent, b_exponent; // Exponents of inputs
reg [22:0] a_mantissa, b_mantissa; // Mantissas of inputs
reg [22:0] product_mantissa; // Mantissa of product
reg [7:0] product_exponent; // Exponent of product
reg product_sign; // Sign bit of product
reg [22:0] normalized_mantissa; // Normalized mantissa
reg [7:0] normalized_exponent; // Normalized exponent
reg [22:0] rounded_mantissa; // Rounded mantissa
reg [7:0] rounded_exponent; // Rounded exponent

// State machine
always @(posedge clk) begin
    if (rst) begin
        state <= 3'b000; // Reset state machine
    end else begin
        case (state)
            3'b000: begin // Input processing
                a_sign <= a[31];
                a_exponent <= a[30:23];
                a_mantissa <= a[22:0];
                b_sign <= b[31];
                b_exponent <= b[30:23];
                b_mantissa <= b[22:0];
                state <= 3'b001; // Move to exponent calculation
            end
            3'b001: begin // Exponent calculation
                product_exponent <= a_exponent + b_exponent - 8'd127;
                state <= 3'b010; // Move to mantissa multiplication
            end
            3'b010: begin // Mantissa multiplication
                product_mantissa <= a_mantissa * b_mantissa;
                state <= 3'b011; // Move to normalization
            end
            3'b011: begin // Normalization
                normalized_mantissa <= product_mantissa;
                normalized_exponent <= product_exponent;
                state <= 3'b100; // Move to rounding
            end
            3'b100: begin // Rounding
                rounded_mantissa <= normalized_mantissa;
                rounded_exponent <= normalized_exponent;
                state <= 3'b101; // Move to output formatting
            end
            3'b101: begin // Output formatting
                z <= {a_sign ^ b_sign, rounded_exponent, rounded_mantissa};
                state <= 3'b000; // Reset state machine
            end
            default: state <= 3'b000;
        endcase
    end
end

// Special case handling for NaN and infinity
always @(*) begin
    if ((a_exponent == 8'd255 && a_mantissa != 23'd0) || (b_exponent == 8'd255 && b_mantissa != 23'd0)) begin
        // NaN or infinity handling
        z <= 32'd0; // Set output to zero
    end
end

// Rounding and normalization logic
always @(*) begin
    if (normalized_mantissa[22] == 1'b1) begin
        // Mantissa overflow, adjust exponent and mantissa
        rounded_exponent <= rounded_exponent + 1;
        rounded_mantissa <= normalized_mantissa >> 1;
    end else if (normalized_mantissa[22] == 1'b0) begin
        // Mantissa underflow, adjust exponent and mantissa
        rounded_exponent <= rounded_exponent - 1;
        rounded_mantissa <= normalized_mantissa << 1;
    end
end

endmodule