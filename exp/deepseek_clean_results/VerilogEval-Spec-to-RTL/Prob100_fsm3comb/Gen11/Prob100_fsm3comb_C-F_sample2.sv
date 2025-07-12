module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

// State transition logic using case statement (from Example 1)
always @(*) begin
    case (state)
        2'b00: next_state = in ? 2'b01 : 2'b00;  // State A
        2'b01: next_state = in ? 2'b01 : 2'b10;  // State B
        2'b10: next_state = in ? 2'b11 : 2'b00;  // State C
        2'b11: next_state = in ? 2'b01 : 2'b10;  // State D
        default: next_state = 2'b00;             // Fallback
    endcase
end

// Direct output assignment (from Example 2)
assign out = (state == 2'b11); // 1 when in state D

endmodule