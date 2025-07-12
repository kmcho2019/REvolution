module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output reg out
);

always @(*) begin
    // Default assignments
    next_state = 4'b0000;
    out = 1'b0;
    
    // State transition logic
    case (1'b1)
        state[0]: next_state = in ? 4'b0010 : 4'b0001; // A -> B if in=1, else A
        state[1]: next_state = in ? 4'b0010 : 4'b0100; // B -> B if in=1, else C
        state[2]: next_state = in ? 4'b1000 : 4'b0001; // C -> D if in=1, else A
        state[3]: next_state = in ? 4'b0010 : 4'b0100; // D -> B if in=1, else C
        default: next_state = 4'b0001; // Default to state A
    endcase
    
    // Output logic (Moore machine: output depends only on current state)
    out = state[3]; // Output 1 only when in state D (one-hot bit 3)
end

endmodule