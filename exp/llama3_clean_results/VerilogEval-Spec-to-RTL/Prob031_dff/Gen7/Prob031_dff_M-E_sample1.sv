module TopModule(
    input clk,
    input d,
    output reg q
);

reg internal_q;

always @(*) begin
    if (clk) begin
        internal_q = d;
    end else begin
        q = internal_q;
    end
end

endmodule