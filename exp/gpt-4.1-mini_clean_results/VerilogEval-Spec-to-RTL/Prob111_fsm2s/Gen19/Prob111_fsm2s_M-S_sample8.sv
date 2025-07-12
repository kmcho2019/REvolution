module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state; // 0: OFF, 1: ON
    assign out = state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0; // OFF
        end else if (state == 1'b0) begin
            state <= j ? 1'b1 : 1'b0;
        end else begin
            state <= k ? 1'b0 : 1'b1;
        end
    end

endmodule