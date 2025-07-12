module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;
    wire next_state;

    // Combinational next state logic
    assign next_state = (state == 1'b0) ? j : ~k;

    // Dual-edge triggered state register
    always @(posedge clk or negedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to OFF state
        end else begin
            state <= next_state;
        end
    end

    // Output is directly the state (Moore machine)
    assign out = state;

endmodule