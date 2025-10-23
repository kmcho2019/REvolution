module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state; // 1=B, 0=A

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b1; // Reset to state B
        end else if (~in) begin
            state <= ~state; // Toggle state when in=0
        end
    end

    assign out = state; // Output is current state

endmodule