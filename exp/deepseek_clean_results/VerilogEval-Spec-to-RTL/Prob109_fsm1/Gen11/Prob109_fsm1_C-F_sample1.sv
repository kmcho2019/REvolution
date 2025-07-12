module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions for clarity
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= STATE_B;  // Async reset to STATE_B
        else
            // Efficient state transition logic:
            // STATE_B stays when in=1, transitions to STATE_A when in=0
            // STATE_A stays when in=1, transitions to STATE_B when in=0
            state <= state ? in : ~in;
    end

    // Output is simply the current state (Moore machine)
    assign out = state;

endmodule