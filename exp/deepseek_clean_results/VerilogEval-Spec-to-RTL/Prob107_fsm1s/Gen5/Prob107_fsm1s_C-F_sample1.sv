module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding: A=0, B=1 (output equals state)
    reg state;  // 0=A, 1=B

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b1;  // Reset to state B
        end else begin
            // Simplified state transition:
            // B->A when in=0, else stay
            // A->B when in=0, else stay
            state <= in ? state : ~state;
        end
    end

    // Output equals state (B=1, A=0)
    assign out = state;

endmodule