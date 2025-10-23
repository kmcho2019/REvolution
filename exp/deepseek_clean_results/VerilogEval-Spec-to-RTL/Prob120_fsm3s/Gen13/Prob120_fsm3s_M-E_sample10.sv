module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot state encoding: A=0001, B=0010, C=0100, D=1000
    reg [3:0] state;
    wire [3:0] next_state_0, next_state_1;
    wire [3:0] next_state;

    // Parallel next state computation for in=0
    assign next_state_0 = (state == 4'b0001) ? 4'b0001 :  // A->A
                          (state == 4'b0010) ? 4'b0100 :  // B->C
                          (state == 4'b0100) ? 4'b0001 :  // C->A
                          (state == 4'b1000) ? 4'b0100 :  // D->C
                          4'b0001;                        // default->A

    // Parallel next state computation for in=1
    assign next_state_1 = (state == 4'b0001) ? 4'b0010 :  // A->B
                          (state == 4'b0010) ? 4'b0010 :  // B->B
                          (state == 4'b0100) ? 4'b1000 :  // C->D
                          (state == 4'b1000) ? 4'b0010 :  // D->B
                          4'b0001;                        // default->A

    // Select correct next state based on input
    assign next_state = in ? next_state_1 : next_state_0;

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= 4'b0001;  // Reset to state A
        else
            state <= next_state;
    end

    // Output logic - only high in state D (1000)
    assign out = state[3];

endmodule