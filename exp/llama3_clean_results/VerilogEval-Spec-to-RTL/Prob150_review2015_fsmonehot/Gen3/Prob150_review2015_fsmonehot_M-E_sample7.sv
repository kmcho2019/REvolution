module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Current state
    wire S     = state[0];
    wire S1    = state[1];
    wire S11   = state[2];
    wire S110  = state[3];
    wire B0    = state[4];
    wire B1    = state[5];
    wire B2    = state[6];
    wire B3    = state[7];
    wire Count = state[8];
    wire Wait  = state[9];

    // Next-state logic
    reg [9:0] next_state;
    always @(*) begin
        case ({S, S1, S11, S110, B0, B1, B2, B3, Count, Wait})
            10'b0000000001: // S
                if (~d) next_state = 10'b0000000001; // S
                else next_state = 10'b0000000010; // S1
            10'b0000000010: // S1
                if (~d) next_state = 10'b0000000001; // S
                else next_state = 10'b0000000100; // S11
            10'b0000000100: // S11
                if (~d) next_state = 10'b0000001000; // S110
                else next_state = 10'b0000000100; // S11
            10'b0000001000: // S110
                if (~d) next_state = 10'b0000000001; // S
                else next_state = 10'b0000000010; // B0
            10'b0000000011: // B0
                next_state = 10'b0000000101; // B1
            10'b0000000101: // B1
                next_state = 10'b0000001010; // B2
            10'b0000001010: // B2
                next_state = 10'b0000010100; // B3
            10'b0000010100: // B3
                next_state = 10'b0000101000; // Count
            10'b0000101000: // Count
                if (~done_counting) next_state = 10'b0000101000; // Count
                else next_state = 10'b0010100000; // Wait
            10'b0010100000: // Wait
                if (~ack) next_state = 10'b0010100000; // Wait
                else next_state = 10'b0000000001; // S
            default:
                next_state = 10'b0000000001; // S
        endcase
    end

    // Output signals
    assign B3_next  = next_state[7];
    assign S_next   = next_state[0];
    assign S1_next  = next_state[1];
    assign Count_next = next_state[8];
    assign Wait_next = next_state[9];
    assign shift_ena = B0 || B1 || B2 || B3;
    assign counting  = Count;
    assign done      = Wait;

endmodule