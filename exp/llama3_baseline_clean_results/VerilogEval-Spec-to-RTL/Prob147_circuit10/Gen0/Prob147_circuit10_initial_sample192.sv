module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    state <= ~(a & b);
    if (!(a & b)) begin
        if (a == 1'b0 && b == 1'b1)
            state <= 1'b1;
        else if (a == 1'b1 && b == 1'b1)
            state <= 1'b0;
    end
end

always @(*) begin
    q = ~(a & b);
end

endmodule