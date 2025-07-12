module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

    // One-hot encoding of states
    // state[0] = 000
    // state[1] = 001
    // state[2] = 010
    // state[3] = 011
    // state[4] = 100
    reg [4:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        // Default next state is all zeros (should not happen)
        next_state = 5'b00000;
        case (1'b1) // priority encoding based on current state bits
            state[0]: next_state = (x == 1'b0) ? 5'b00001 : 5'b00010; // 000->000 or 001
            state[1]: next_state = (x == 1'b0) ? 5'b00010 : 5'b10000; // 001->001 or 100
            state[2]: next_state = (x == 1'b0) ? 5'b00100 : 5'b00010; // 010->010 or 001
            state[3]: next_state = (x == 1'b0) ? 5'b00010 : 5'b00100; // 011->001 or 010
            state[4]: next_state = (x == 1'b0) ? 5'b01000 : 5'b10000; // 100->011 or 100
            default: next_state = 5'b00001; // reset state 000
        endcase
    end

    // Output logic: z=1 when in states 011 or 100 => state[3] or state[4]
    always @(*) begin
        z = state[3] | state[4];
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= 5'b00001;  // state 000 encoded as state[0]=1
        else
            state <= next_state;
    end

endmodule