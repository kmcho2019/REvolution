module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);
    // One-hot state encoding
    localparam
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000;

    reg [3:0] state, next_state;

    // Next state logic combinational block (one-hot)
    always @(*) begin
        // Default next_state to zero to avoid inferred latches
        next_state = 4'b0000;
        case (1'b1) // priority encoding to check which bit is 1 in state
            state[0]: next_state = (in == 1'b0) ? A : B;  // A state
            state[1]: next_state = (in == 1'b0) ? C : B;  // B state
            state[2]: next_state = (in == 1'b0) ? A : D;  // C state
            state[3]: next_state = (in == 1'b0) ? C : B;  // D state
            default: next_state = A;  // In case of invalid state, reset to A
        endcase
    end

    // State register with asynchronous active high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Moore output logic directly from state bit D
    always @(*) begin
        out = state[3]; // output 1 when in D state (one-hot bit 3)
    end

endmodule