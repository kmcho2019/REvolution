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
        end else if (state == 1'b0) begin  // State B
            state <= in ? 1'b0 : 1'b1;
        end else begin  // State A
            state <= in ? 1'b1 : 1'b0;
        end
    end

    assign out = ~state;  // out=1 when state=B (0)

endmodule