module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state; // 0=A, 1=B

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b1; // Reset to state B
        end else begin
            if (state) begin // State B
                state <= in ? 1'b1 : 1'b0;
            end else begin // State A
                state <= in ? 1'b0 : 1'b1;
            end
        end
    end

    assign out = state; // Output equals state (B=1, A=0)

endmodule