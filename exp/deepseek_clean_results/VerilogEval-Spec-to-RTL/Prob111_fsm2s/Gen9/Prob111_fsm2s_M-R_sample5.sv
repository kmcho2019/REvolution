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
    assign next_state = (state == 1'b0) ? j : ~k;

    // Sequential state update
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

    // Output assignment
    assign out = state;

endmodule