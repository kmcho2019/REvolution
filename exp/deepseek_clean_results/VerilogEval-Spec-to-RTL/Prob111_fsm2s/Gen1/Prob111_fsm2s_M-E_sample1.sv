module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;

    // Toggle logic: toggle when (state=0 and j=1) or (state=1 and k=1)
    wire toggle_enable = (state == 0) ? j : k;

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
        end else if (toggle_enable) begin
            state <= ~state;
        end
    end

    assign out = state;

endmodule