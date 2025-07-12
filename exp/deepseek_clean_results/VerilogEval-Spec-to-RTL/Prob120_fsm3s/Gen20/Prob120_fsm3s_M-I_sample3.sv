module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot state encoding (A=0001, B=0010, C=0100, D=1000)
    reg [3:0] state, next_state;

    // Next state logic using parallel assignments
    always @(*) begin
        next_state[0] = (~in & (state[0] | state[2]));  // A or C when in=0
        next_state[1] = (in & (state[0] | state[3])) | (state[1] & in);  // B from A/D or stay B
        next_state[2] = (~in & state[1]) | (in & state[2]);  // C from B or stay C
        next_state[3] = in & state[2];  // D from C when in=1
    end

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= 4'b0001;  // Reset to state A (one-hot)
        else
            state <= next_state;
    end

    // Output logic - directly tied to D state bit
    assign out = state[3];

endmodule