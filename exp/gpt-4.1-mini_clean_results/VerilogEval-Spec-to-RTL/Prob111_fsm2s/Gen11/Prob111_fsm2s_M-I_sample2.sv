module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;       // 0 = OFF, 1 = ON
    wire next_state;

    // Next state logic
    assign next_state = state ? (k ? 1'b0 : 1'b1) : (j ? 1'b1 : 1'b0);

    // Clock gating enable: update state only when next_state differs from current state or reset is active
    wire clk_en = reset | (next_state != state);
    wire gated_clk = clk & clk_en;

    always @(posedge gated_clk) begin
        if (reset)
            state <= 1'b0; // OFF state
        else
            state <= next_state;
    end

    assign out = state;

endmodule