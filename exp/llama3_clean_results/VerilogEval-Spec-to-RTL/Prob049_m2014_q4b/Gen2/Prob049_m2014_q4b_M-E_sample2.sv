module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

reg internal_q;

always @(*) begin
    if (ar) begin
        internal_q = 0;
    end else begin
        internal_q = q;
    end
end

always @(posedge clk) begin
    q <= internal_q;
    internal_q <= d;
end

endmodule