module TopModule(
    input  clk,
    input  a,
    output [2:0] q
);

reg [2:0] q;
reg a_prev;

always @(posedge clk) begin
    a_prev <= a;
    if (~a && a_prev) begin
        q <= q + 1;
        if (q == 7) begin
            q <= 0;
        end
    end
end

endmodule