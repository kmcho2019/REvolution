module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding using localparams for clarity
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // Next state bits combinational logic derived directly from state and input to reduce logic levels
    // Next state MSB (bit 1)
    assign next_state[1] = (state == B) ? 1'b1 :
                           (state == C) ? in :
                           (state == D) ? 1'b1 : 1'b0; // A or default -> 0

    // Next state LSB (bit 0)
    assign next_state[0] = (state == A) ? in :
                           (state == B) ? 1'b0 :
                           (state == C) ? 1'b0 :
                           (state == D) ? (in ? 1'b1 : 1'b0) : 1'b0;

    // Moore output depends only on the current state
    assign out = (state == D);

endmodule