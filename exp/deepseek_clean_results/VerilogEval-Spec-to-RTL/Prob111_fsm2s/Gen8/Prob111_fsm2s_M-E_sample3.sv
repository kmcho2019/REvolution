module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;  // Single bit state storage

    // Next state is (state AND NOT k) OR (NOT state AND j)
    wire next_state = (state & ~k) | (~state & j);

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to OFF (0)
        end else begin
            state <= next_state;
        end
    end

    // Output is simply the current state
    assign out = state;

endmodule