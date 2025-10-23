module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;
    end else if (q == 6) begin
        q <= 3'd0;
    end else if (q == 0) begin
        q <= 3'd1;
    end else begin
        q <= q + 1;
    end
end

endmodule