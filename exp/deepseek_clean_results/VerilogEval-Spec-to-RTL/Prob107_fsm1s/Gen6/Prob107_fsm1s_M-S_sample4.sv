module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0=B, 1=A

    always @(posedge clk) begin
        if (reset)
            state <= 0;  // Reset to state B
        else
            state <= (state & in) | (~state & ~in);
    end

    assign out = ~state;  // out=1 when in state B

endmodule