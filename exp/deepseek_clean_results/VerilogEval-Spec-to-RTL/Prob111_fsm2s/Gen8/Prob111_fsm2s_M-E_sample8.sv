module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;  // 0 = OFF, 1 = ON
    wire toggle_enable = state ? k : j;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;
        end else if (toggle_enable) begin
            state <= ~state;
        end
    end

    assign out = state;

endmodule