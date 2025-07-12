module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (!a) begin
        state <= b;
    end else if (b) begin
        state <= ~state;
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