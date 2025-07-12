module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Output is 1 only in state D (Moore machine)
assign out = (state == 2'b11);

// Next state logic using case statement for better optimization
reg [1:0] next_state_reg;
always @(*) begin
    case (state)
        2'b00: next_state_reg = in ? 2'b01 : 2'b00; // A -> B if in=1, else A
        2'b01: next_state_reg = in ? 2'b01 : 2'b10; // B -> B if in=1, else C
        2'b10: next_state_reg = in ? 2'b11 : 2'b00; // C -> D if in=1, else A
        2'b11: next_state_reg = in ? 2'b01 : 2'b10; // D -> B if in=1, else C
        default: next_state_reg = 2'b00;            // Default to state A
    endcase
end

assign next_state = next_state_reg;

endmodule