module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

reg internal_q;

always @(posedge clk or posedge ar) begin
    if (ar) begin
        internal_q <= 1'b0;
        q <= 1'b0;
    end else if (clk) begin
        internal_q <= d;
        q <= internal_q;
    end
end

endmodule