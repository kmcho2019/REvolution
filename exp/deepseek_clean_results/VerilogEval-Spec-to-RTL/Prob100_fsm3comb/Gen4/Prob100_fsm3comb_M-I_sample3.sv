module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

// Output logic - purely based on current state (Moore machine)
always @(*) begin
    case (state)
        2'b00: out = 1'b0;  // State A
        2'b01: out = 1'b0;  // State B
        2'b10: out = 1'b0;  // State C
        2'b11: out = 1'b1;  // State D
    endcase
end

// Next state logic - based on current state and input
always @(*) begin
    case ({state, in})
        3'b000: next_state = 2'b00;  // A, in=0 → A
        3'b001: next_state = 2'b01;  // A, in=1 → B
        3'b010: next_state = 2'b10;  // B, in=0 → C
        3'b011: next_state = 2'b01;  // B, in=1 → B
        3'b100: next_state = 2'b00;  // C, in=0 → A
        3'b101: next_state = 2'b11;  // C, in=1 → D
        3'b110: next_state = 2'b10;  // D, in=0 → C
        3'b111: next_state = 2'b01;  // D, in=1 → B
    endcase
end

endmodule