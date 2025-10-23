module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (a && b) begin
        state <= 0;
    end else if (!a && b) begin
        state <= 1;
    end
end

always @(*) begin
    if (!a) begin
        q = b;
    end else begin
        q = state;
    end
end

endmodule