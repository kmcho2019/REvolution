module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;       // 0=OFF, 1=ON
    reg next_state;

    // Next state logic combinational block
    always @(*) begin
        case (state)
            1'b0: next_state = j ? 1'b1 : 1'b0; // OFF state transitions
            1'b1: next_state = k ? 1'b0 : 1'b1; // ON state transitions
            default: next_state = 1'b0;          // Default to OFF on unknown state
        endcase
    end

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 1'b0; // OFF
        else
            state <= next_state;
    end

    assign out = state;

endmodule