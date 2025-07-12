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
        end else if (state) begin // State A
            state <= in; // A->A if in=1, A->B if in=0
        end else begin // State B
            state <= ~in; // B->A if in=0, B->B if in=1
        end
    end

    assign out = ~state; // out=1 when B, out=0 when A

endmodule