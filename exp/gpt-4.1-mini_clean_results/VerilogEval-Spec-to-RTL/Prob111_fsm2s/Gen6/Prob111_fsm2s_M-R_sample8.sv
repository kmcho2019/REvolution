module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;      // Current state: 0=OFF, 1=ON
    reg next_state; // Next state combinational logic

    // Combinational logic to determine next state
    always @(*) begin
        if (state == 1'b0) begin
            // OFF state transitions based on j
            if (j)
                next_state = 1'b1;
            else
                next_state = 1'b0;
        end else begin
            // ON state transitions based on k
            if (k)
                next_state = 1'b0;
            else
                next_state = 1'b1;
        end
    end

    // State update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0; // Reset to OFF
        end else begin
            state <= next_state;
        end
    end

    // Moore output depends only on current state
    assign out = state;

endmodule