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
    assign next_state = reset ? 1'b0 :       // Reset condition
                      (state == 1'b0) ? (j ? 1'b1 : 1'b0) :  // OFF state transitions
                      (k ? 1'b0 : 1'b1);     // ON state transitions

    // State register update
    always @(posedge clk) begin
        state <= next_state;
    end

    // Moore output
    assign out = state;

endmodule