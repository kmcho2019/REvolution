module TopModule(
    input  in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

// Next state logic using case statement for clarity and efficiency
always @(*) begin
    case (state)
        2'b00: next_state = in ? 2'b01 : 2'b00; // State A transitions
        2'b01: next_state = in ? 2'b01 : 2'b10; // State B transitions
        2'b10: next_state = in ? 2'b11 : 2'b00; // State C transitions
        2'b11: next_state = in ? 2'b01 : 2'b10; // State D transitions
        default: next_state = 2'b00; // Default state for unused state codes
    endcase
end

// Output logic using assign statement for simplicity and readability
assign out = (state == 2'b11) ? 1'b1 : 1'b0;

endmodule