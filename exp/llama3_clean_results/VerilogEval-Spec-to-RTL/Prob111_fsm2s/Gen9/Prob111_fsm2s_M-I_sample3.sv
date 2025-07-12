module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0;
        out <= 1'b0;
    end else if (state == 1'b0) begin
        if (j) begin
            state <= 1'b1;
            out <= 1'b1;
        end
    end else begin
        if (!k) begin
            state <= 1'b1;
            out <= 1'b1;
        end else begin
            state <= 1'b0;
            out <= 1'b0;
        end
    end
end

endmodule