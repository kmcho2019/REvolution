module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;       // Current state: 0=OFF, 1=ON
    reg next_state;  // Next state combinational signal

    // Next-state logic combinational block
    always @(*) begin
        if (state == 1'b0)  // OFF state
            next_state = j ? 1'b1 : 1'b0;
        else                // ON state
            next_state = k ? 1'b0 : 1'b1;
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    // Moore output directly from state
    assign out = state;

endmodule