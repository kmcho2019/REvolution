module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;  // Single bit state: 0=A, 1=B

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;  // Async reset to state B
        end else begin
            // Toggle when: (in state A and input=0) OR (in state B and input=1)
            if ((~state & ~in) | (state & in)) begin
                state <= ~state;
            end
        end
    end

    // Output is the current state
    assign out = state;

endmodule