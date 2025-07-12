module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    // State transition logic using case statement
    always @(*) begin
        case (1'b1)  // One-hot state decoding
            state[0]: next_state = in ? 4'b0010 : 4'b0001;  // A -> B (in=1) or A (in=0)
            state[1]: next_state = in ? 4'b0010 : 4'b0100;   // B -> B (in=1) or C (in=0)
            state[2]: next_state = in ? 4'b1000 : 4'b0001;   // C -> D (in=1) or A (in=0)
            state[3]: next_state = in ? 4'b0010 : 4'b0100;   // D -> B (in=1) or C (in=0)
            default: next_state = 4'b0001;                   // Default to state A
        endcase
    end

    // Output is high only in state D (one-hot MSB)
    assign out = state[3];

endmodule