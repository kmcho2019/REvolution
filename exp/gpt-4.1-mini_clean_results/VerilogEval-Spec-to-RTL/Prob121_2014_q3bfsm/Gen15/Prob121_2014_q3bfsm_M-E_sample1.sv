module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

    // One-hot state encoding: each bit represents a state
    // States: 
    // S0 = 000 = state[0]
    // S1 = 001 = state[1]
    // S2 = 010 = state[2]
    // S3 = 011 = state[3]
    // S4 = 100 = state[4]
    reg [4:0] state, next_state;

    // Combinational next-state logic
    always @(*) begin
        // Default no transitions
        next_state = 5'b00000;
        case (1'b1) // one-hot style, match which bit is set
            state[0]: next_state = x ? 5'b00010 : 5'b00001; // 000 -> 001 if x=1 else 000
            state[1]: next_state = x ? 5'b10000 : 5'b00010; // 001 -> 100 if x=1 else 001
            state[2]: next_state = x ? 5'b00010 : 5'b00100; // 010 -> 001 if x=1 else 010
            state[3]: next_state = x ? 5'b00100 : 5'b00010; // 011 -> 010 if x=1 else 001
            state[4]: next_state = x ? 5'b10000 : 5'b01000; // 100 -> 100 if x=1 else 011
            default:  next_state = 5'b00001; // Default to initial state
        endcase
    end

    // Output logic combinational: z = 1 for states 011 and 100
    always @(*) begin
        z = state[3] | state[4];
    end

    // Synchronous state register with active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= 5'b00001; // Initial state 000 is state[0]
        else
            state <= next_state;
    end

endmodule