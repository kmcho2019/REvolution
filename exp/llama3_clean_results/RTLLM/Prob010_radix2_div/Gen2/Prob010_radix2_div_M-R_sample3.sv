module radix2_div #(
    parameter WIDTH = 8
) (
    input clk,
    input rst,
    input sign,
    input [WIDTH-1:0] dividend,
    input [WIDTH-1:0] divisor,
    input opn_valid,
    output res_valid,
    output [2*WIDTH-1:0] result
);

// Internal signals
reg [2*WIDTH-1:0] shift_register;  // Shift register
reg [WIDTH-1:0] negated_divisor;  // Negated absolute value of the divisor
reg [2:0] counter;  // Counter
reg start_division;  // Flag to start the division
reg [WIDTH-1:0] quotient;  // Quotient
reg [WIDTH-1:0] remainder;  // Remainder
reg result_valid;  // Result validity flag
reg [1:0] state;  // State machine state

// Define the states
localparam IDLE = 2'b00;
localparam DIVIDE = 2'b01;

// Initialize the state machine
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        start_division <= 0;
        result_valid <= 0;
    end else if (state == IDLE) begin
        if (opn_valid) begin
            // Save the inputs dividend and divisor
            if (sign) begin
                // Signed division
                shift_register <= ({dividend[WIDTH-1]? {WIDTH{1'b1}} : {WIDTH{1'b0}}} + dividend) << 1;
                negated_divisor <= ({divisor[WIDTH-1]? {WIDTH{1'b1}} : {WIDTH{1'b0}}} + divisor);
            end else begin
                // Unsigned division
                shift_register <= dividend << 1;
                negated_divisor <= divisor;
            end
            counter <= 1;
            start_division <= 1;
            state <= DIVIDE;
        end
    end else if (state == DIVIDE) begin
        if (counter == WIDTH) begin
            // Division complete
            start_division <= 0;
            result_valid <= 1;
            quotient <= shift_register[WIDTH-1:0];
            remainder <= shift_register[2*WIDTH-1:WIDTH];
            state <= IDLE;
        end else begin
            // Update the shift register and counter
            reg [WIDTH:0] subtraction;
            subtraction = {1'b0, shift_register[2*WIDTH-1:WIDTH]} - negated_divisor;
            if (subtraction[WIDTH]) begin
                // No borrow
                shift_register <= {1'b0, shift_register[2*WIDTH-1:WIDTH]} << 1;
            end else begin
                // Borrow
                shift_register <= {1'b1, shift_register[2*WIDTH-1:WIDTH]} + (negated_divisor << 1);
            end
            counter <= counter + 1;
        end
    end
end

// Assign the result
assign result = {remainder, quotient};
assign res_valid = result_valid;

endmodule