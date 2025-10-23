module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0=B, 1=A

    always @(posedge clk) begin
        if (reset) state <= 0;
        else state <= in ? state : ~state;
    end

    assign out = ~state;

endmodule