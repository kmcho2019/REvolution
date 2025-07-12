module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (a) begin
        state <= state;
    end else begin
        state <= b;
    end
end

always @(*) begin
    if (a) begin
        q = ~b;
    end else begin
        q = b;
    end
end

endmodule