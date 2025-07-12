module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // One-hot like encoding for states:
    // 00000 - invalid (reset to 00001)
    // 00001 - state 000
    // 00010 - state 001
    // 00100 - state 010
    // 01000 - state 011
    // 10000 - state 100
    reg [4:0] state;

    // Next state logic
    wire [4:0] next_state;
    assign next_state = 
        (state[0] & ~x) ? 5'b00001 :  // 000 -> 000 (x=0)
        (state[0] &  x) ? 5'b00010 :  // 000 -> 001 (x=1)
        (state[1] & ~x) ? 5'b00010 :  // 001 -> 001 (x=0)
        (state[1] &  x) ? 5'b10000 :  // 001 -> 100 (x=1)
        (state[2] & ~x) ? 5'b00100 :  // 010 -> 010 (x=0)
        (state[2] &  x) ? 5'b00010 :  // 010 -> 001 (x=1)
        (state[3] & ~x) ? 5'b00010 :  // 011 -> 001 (x=0)
        (state[3] &  x) ? 5'b00100 :  // 011 -> 010 (x=1)
        (state[4] & ~x) ? 5'b01000 :  // 100 -> 011 (x=0)
        (state[4] &  x) ? 5'b10000 :  // 100 -> 100 (x=1)
        5'b00001;                     // default to state 000

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 5'b00001;
        else
            state <= next_state;
    end

    // Output logic - states 011 (01000) and 100 (10000) output 1
    assign z = state[3] | state[4];

endmodule