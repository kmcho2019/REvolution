module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 0;
        out <= 0;
    end else if (state == 0) begin
        if (j) begin
            state <= 1;
            out <= 1;
        end
    end else begin
        if (~k) begin
            state <= 1;
            out <= 1;
        end else begin
            state <= 0;
            out <= 0;
        end
    end
end

endmodule