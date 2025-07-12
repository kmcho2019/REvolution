module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;
        end else begin
            state <= (state & ~k) | (~state & j);
        end
    end

    assign out = state;

endmodule