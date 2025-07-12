module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State register (0=B, 1=A)
    reg state;

    // State transition with ternary expression
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to state B
        end else begin
            state <= (state) ? (in ? 1'b1 : 1'b0)  // Current state A
                             : (in ? 1'b0 : 1'b1); // Current state B
        end
    end

    // Output is 1 when in state B (state=0)
    assign out = ~state;

endmodule