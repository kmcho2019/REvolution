module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    reg [3:0] state;  // bits represent states A,B,C,D respectively

    // Parallel next state logic
    wire [3:0] next_state;
    assign next_state[0] = (~state[0] | ~in) &  // A stays if in=0
                          (~state[1] | in) &    // B stays if in=1
                          (state[2] & ~in);     // C->A if in=0
    
    assign next_state[1] = (state[0] & in) |    // A->B if in=1
                          (state[1] & in) |     // B stays if in=1
                          (state[3] & in);     // D->B if in=1
    
    assign next_state[2] = (state[1] & ~in) |   // B->C if in=0
                          (state[3] & ~in);     // D->C if in=0
    
    assign next_state[3] = (state[2] & in);     // C->D if in=1

    // Sequential state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 4'b0001;  // Reset to state A (LSB)
        else
            state <= next_state;
    end

    // Output is simply the D state bit
    assign out = state[3];

endmodule