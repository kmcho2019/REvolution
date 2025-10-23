module TopModule(
    input  clk,
    input  ar,
    input  d,
    output reg q
);

always @(*) begin
    if (ar) begin
        q <= 1'b0; // Asynchronous reset
    end
end

always @(posedge clk) begin
    if (!ar) begin
        q <= d; // Capture input d on positive edge of clk
    end
end

endmodule