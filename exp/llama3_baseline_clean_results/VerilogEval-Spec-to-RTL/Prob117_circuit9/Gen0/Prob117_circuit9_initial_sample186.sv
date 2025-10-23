module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

always @(posedge clk) begin
    if (a == 1) begin
        q <= 4;
    end else if (q == 7 - 1) begin // 7 - 1 because q is 0-indexed
        q <= 0;
    end else begin
        q <= q + 1;
    end
end

endmodule