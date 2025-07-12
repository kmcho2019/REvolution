module TopModule (
    input clk,
    input in,
    output out
);
    reg state;

    always @(posedge clk) begin
        state <= in ^ state;
    end

    assign out = state;
endmodule