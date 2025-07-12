module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0=B, 1=A

    always @(posedge clk) begin
        if (reset) state <= 1'b0;
        else state <= (state & in) | (~state & ~in);
    end

    assign out = ~state;

endmodule