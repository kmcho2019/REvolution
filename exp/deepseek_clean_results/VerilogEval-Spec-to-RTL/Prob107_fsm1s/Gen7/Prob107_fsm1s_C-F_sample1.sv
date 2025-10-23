module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding (1 bit binary)
    reg state; // 0=B, 1=A

    // Compact state transition logic
    always @(posedge clk) begin
        if (reset)
            state <= 1'b0; // Reset to state B
        else
            state <= in ? state : ~state; // Toggle state when in=0
    end

    // Simple combinational output logic
    assign out = ~state; // out=1 when state=B (0), out=0 when state=A (1)

endmodule