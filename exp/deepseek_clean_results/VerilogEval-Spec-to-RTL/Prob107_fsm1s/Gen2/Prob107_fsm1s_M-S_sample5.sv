module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state; // 1=B, 0=A

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b1; // Reset to state B
        end else begin
            state <= in ? state : ~state; // Toggle if in=0, else maintain
        end
    end

    assign out = state; // Output directly follows state

endmodule