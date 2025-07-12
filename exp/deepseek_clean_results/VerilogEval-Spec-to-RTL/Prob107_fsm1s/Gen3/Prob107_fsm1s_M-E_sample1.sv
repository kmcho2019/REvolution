module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0=B, 1=A

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to state B
        end else begin
            state <= state ? (in) : (state ^ ~in);
            // Equivalent to:
            // if (state) state <= in;        // A state
            // else state <= in ? 1'b0 : 1'b1; // B state
        end
    end

    assign out = ~state;  // out=1 when in state B

endmodule