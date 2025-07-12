module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0=B, 1=A

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;  // Reset to state B
        end else begin
            state <= state ? in : ~in;
        end
    end

    assign out = ~state;  // out=1 when state=0 (B)

endmodule