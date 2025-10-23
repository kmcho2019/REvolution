module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot state encoding: A=0001, B=0010, C=0100, D=1000
    reg [3:0] state;

    // Next state wires
    wire [3:0] next_state;

    // State transitions using continuous assignments
    assign next_state[0] = (~reset) & ((state[0] & ~in) | (state[2] & ~in));  // A or C->A
    assign next_state[1] = (~reset) & ((state[0] & in) | (state[1] & in) | (state[3] & in));  // A->B or B->B or D->B
    assign next_state[2] = (~reset) & ((state[1] & ~in) | (state[3] & ~in));  // B->C or D->C
    assign next_state[3] = (~reset) & (state[2] & in);  // C->D

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= 4'b0001;  // Reset to state A
        end else begin
            state <= next_state;
        end
    end

    // Output is high only in state D (1000)
    assign out = state[3];

endmodule