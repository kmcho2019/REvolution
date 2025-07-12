module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

always @(*) begin
    // Default outputs
    next_state = 10'b0;
    out1 = 1'b0;
    out2 = 1'b0;

    // Handle outputs first (only S7-S9 have non-zero outputs)
    if (state[7]) out2 = 1'b1;
    if (state[8]) out1 = 1'b1;
    if (state[9]) {out1, out2} = 2'b11;

    // Handle state transitions using case statement
    case (1'b1)
        state[0]: next_state = in ? 10'b0000000010 : 10'b0000000001;
        state[1]: next_state = in ? 10'b0000000100 : 10'b0000000001;
        state[2]: next_state = in ? 10'b0000001000 : 10'b0000000001;
        state[3]: next_state = in ? 10'b0000010000 : 10'b0000000001;
        state[4]: next_state = in ? 10'b0000100000 : 10'b0000000001;
        state[5]: next_state = in ? 10'b0001000000 : 10'b0010000000;
        state[6]: next_state = in ? 10'b0100000000 : 10'b1000000000;
        state[7]: next_state = in ? 10'b0100000000 : 10'b0000000001;
        state[8]: next_state = in ? 10'b0000000010 : 10'b0000000001;
        state[9]: next_state = in ? 10'b0000000010 : 10'b0000000001;
        default:   next_state = 10'b0000000001;  // Default to S0
    endcase
end

endmodule