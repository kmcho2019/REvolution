module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    state <= q;
end

always @(*) begin
    if (b == 1'b1) begin
        q = 1'b1;
    end else if (state == 1'b1 && a == 1'b1) begin
        q = 1'b1;
    end else begin
        q = 1'b0;
    end
end

endmodule