module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

reg latch1, latch2;

always @(posedge clk or posedge ar) begin
    if (ar) begin
        latch1 <= 1'b0;
        latch2 <= 1'b0;
    end else if (clk) begin
        latch1 <= d;
        latch2 <= latch1;
    end
end

always @(*) begin
    q = latch2;
end

endmodule