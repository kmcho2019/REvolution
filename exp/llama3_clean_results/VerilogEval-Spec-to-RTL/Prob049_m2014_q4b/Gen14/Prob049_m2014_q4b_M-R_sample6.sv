module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk) begin
    if (!ar) begin
        q <= d;
    end
end

always @(posedge ar) begin
    q <= 1'b0;
end

endmodule