module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1;
        end else begin
            state <= (state & in) | (~state & ~in);
        end
    end

    assign out = state;

endmodule