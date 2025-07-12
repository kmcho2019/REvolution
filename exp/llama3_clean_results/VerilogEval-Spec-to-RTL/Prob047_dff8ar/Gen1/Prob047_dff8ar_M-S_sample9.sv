module TopModule(
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

always @(*) begin
    if (areset) begin
        q = 8'b0;
    end else begin
        q = d;
    end
end

always @(posedge clk) begin
    q <= q;
end

endmodule