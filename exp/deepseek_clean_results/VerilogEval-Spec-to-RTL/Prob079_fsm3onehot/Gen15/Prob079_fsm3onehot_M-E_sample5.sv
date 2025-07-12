module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    // LUT for state transitions [current_state][in] -> next_state
    always @(*) begin
        case ({state, in})
            5'b0001_0: next_state = 4'b0001; // A,0->A
            5'b0001_1: next_state = 4'b0010; // A,1->B
            5'b0010_0: next_state = 4'b0100; // B,0->C
            5'b0010_1: next_state = 4'b0010; // B,1->B
            5'b0100_0: next_state = 4'b0001; // C,0->A
            5'b0100_1: next_state = 4'b1000; // C,1->D
            5'b1000_0: next_state = 4'b0100; // D,0->C
            5'b1000_1: next_state = 4'b0010; // D,1->B
            default:   next_state = 4'b0001; // Default to A
        endcase
    end

    // Output is high only in state D (one-hot MSB)
    assign out = state[3];

endmodule