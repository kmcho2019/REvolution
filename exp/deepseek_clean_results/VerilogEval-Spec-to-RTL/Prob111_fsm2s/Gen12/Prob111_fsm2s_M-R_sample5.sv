module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;  // 0 = OFF, 1 = ON

    // Sequential state update with direct transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;
        end else begin
            state <= (state == 1'b0) ? j : ~k;
        end
    end

    // Output assignment
    assign out = state;

endmodule