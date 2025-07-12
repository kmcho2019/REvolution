module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;  // 0 = OFF, 1 = ON
    reg next_state;

    // Compute next state combinationally
    always @(*) begin
        if (state == 1'b0) begin
            // OFF state: next depends on j
            next_state = j ? 1'b1 : 1'b0;
        end else begin
            // ON state: next depends on k
            next_state = k ? 1'b0 : 1'b1;
        end
    end

    // State update with synchronous reset and update gating
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0; // OFF state on reset
        end else if (state != next_state) begin
            state <= next_state; // update only if changed
        end
        // else retain current state without toggling
    end

    assign out = state; // Moore output depends only on state

endmodule