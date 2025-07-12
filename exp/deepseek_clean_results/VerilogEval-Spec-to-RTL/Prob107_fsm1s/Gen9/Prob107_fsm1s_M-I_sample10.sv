module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state; // 0=B, 1=A

    always @(posedge clk) begin
        if (reset) begin
            state <= 0; // Reset to state B
        end else begin
            state <= (state & in) | (~state & ~in);
        end
    end

    assign out = ~state; // Inverted since B=0 (out=1) and A=1 (out=0)

endmodule