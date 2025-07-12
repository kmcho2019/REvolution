module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

reg mid_q;

always @(posedge clk) begin
    mid_q <= d;
end

always @(*) begin
    if (ar) q = 1'b0;
    else   q = mid_q;
end

endmodule