module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;  // 0 = OFF, 1 = ON
    wire next_state;

    // Combinational next state logic
    assign next_state = (~state & j) | (state & ~k);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to OFF state
        end else begin
            state <= next_state;
        end
    end

    // Moore output depends only on state
    assign out = state;

endmodule