module TopModule(
    input clk,
    input d,
    output reg q = 0
);

reg internal_q;

always @(posedge clk) begin
    internal_q <= d;
end

always @(*) begin
    if (clk) begin
        q = internal_q;
    end else begin
        q = internal_q;
    end
end

endmodule