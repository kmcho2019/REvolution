module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0=B, 1=A

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to B
        end else begin
            state <= state ? in : ~in;  // A stays if in=1, B stays if in=1
        end
    end

    assign out = ~state;  // Direct output mapping

endmodule