module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

initial q = 4;

always @(posedge clk) begin
    if (~a) begin
        if (q == 7)
            q <= 0;
        else
            q <= q + 1;
    end
end

endmodule