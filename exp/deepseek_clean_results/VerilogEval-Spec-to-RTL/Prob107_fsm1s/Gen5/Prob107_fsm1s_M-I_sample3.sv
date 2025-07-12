module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State register (0=B, 1=A)
    reg state;

    // State transition and reset logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to state B
        end else begin
            state <= state ? (in ? 1'b1 : 1'b0) :  // Current state A
                            (in ? 1'b0 : 1'b1);   // Current state B
        end
    end

    // Output logic (Moore)
    assign out = ~state;  // out=1 when in state B (0), out=0 when in state A (1)

endmodule