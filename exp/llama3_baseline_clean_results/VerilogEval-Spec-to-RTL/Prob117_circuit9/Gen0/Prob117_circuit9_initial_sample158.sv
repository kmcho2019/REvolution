module TopModule(
    input  clk,
    input  a,
    output [2:0] q
);

reg [2:0] q;

initial q = 4;

always @(posedge clk) begin
    if (!a) begin
        q <= q + 1;
        if (q == 7) begin
            q <= 0;
        end
    end
end

endmodule