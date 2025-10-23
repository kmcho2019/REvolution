module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

// Internal signals
reg [15:0] shift_register;  // Shift register
reg [7:0] negated_divisor;  // Negated absolute value of the divisor
reg [2:0] counter;  // Counter
reg start_division;  // Flag to start the division
reg [7:0] quotient;  // Quotient
reg [7:0] remainder;  // Remainder
reg result_valid;  // Result validity flag

// Initialize the shift register, negated divisor, counter, and start flag
always @(posedge clk or posedge rst) begin
    if (rst) begin
        shift_register <= 0;
        negated_divisor <= 0;
        counter <= 0;
        start_division <= 0;
        result_valid <= 0;
    end else if (opn_valid &&!result_valid) begin
        // Save the inputs dividend and divisor
        if (sign) begin
            // Signed division
            shift_register <= ({dividend[7]? 8'hff : 8'h00} + dividend) << 1;
            negated_divisor <= ({divisor[7]? 8'hff : 8'h00} + divisor);
        end else begin
            // Unsigned division
            shift_register <= dividend << 1;
            negated_divisor <= divisor;
        end
        counter <= 1;
        start_division <= 1;
        result_valid <= 0;
    end else if (start_division) begin
        // Perform the division process
        if (counter == 8) begin
            // Division complete
            start_division <= 0;
            result_valid <= 1;
            quotient <= shift_register[7:0];
            remainder <= shift_register[15:8];
        end else begin
            // Update the shift register and counter
            reg [8:0] subtraction;
            subtraction = {1'b0, shift_register[15:8]} - negated_divisor;
            if (subtraction[8]) begin
                // No borrow
                shift_register <= {1'b0, shift_register[15:8]} << 1;
            end else begin
                // Borrow
                shift_register <= {1'b1, shift_register[15:8]} + (negated_divisor << 1);
            end
            counter <= counter + 1;
        end
    end
end

// Assign the result
assign result = {remainder, quotient};
assign res_valid = result_valid;

endmodule