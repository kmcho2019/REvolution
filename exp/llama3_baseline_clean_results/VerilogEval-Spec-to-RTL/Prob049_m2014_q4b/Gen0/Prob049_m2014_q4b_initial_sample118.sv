module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(*) begin
    if (ar) begin
        q <= 0;
    end else if (posedge clk) begin
        q <= d;
    end
end

endmodule