module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot state encoding (A=0001, B=0010, C=0100, D=1000)
    reg [3:0] state, next_state;

    // Next state logic
    always @(*) begin
        next_state = 4'b0000;  // Default to avoid latches
        case (1'b1)  // Synthesis will optimize this to parallel case
            state[0]: next_state = in ? 4'b0010 : 4'b0001;  // A -> B or A
            state[1]: next_state = in ? 4'b0010 : 4'b0100;  // B -> B or C
            state[2]: next_state = in ? 4'b1000 : 4'b0001;  // C -> D or A
            state[3]: next_state = in ? 4'b0010 : 4'b0100;  // D -> B or C
        endcase
    end

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= 4'b0001;  // Reset to state A (0001)
        else
            state <= next_state;
    end

    // Output logic - directly from state D bit
    assign out = state[3];

endmodule