module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

always @(posedge clk) begin
    if (a == 1) begin
        q <= 4;
    end else if (q == 6) begin
        q <= 0;
    end else if (q == 0) begin
        q <= 1;
    end else begin
        q <= q + 1;
    end
end

endmodule