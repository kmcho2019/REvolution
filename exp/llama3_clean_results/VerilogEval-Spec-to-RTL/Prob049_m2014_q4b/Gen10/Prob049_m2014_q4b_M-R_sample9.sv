module TopModule(
    input  clk,
    input  ar,
    input  d,
    output reg q
);

always @(posedge ar) begin
    q <= 0;
end

always @(posedge clk) begin
    if (!ar) begin
        q <= d;
    end
end

endmodule