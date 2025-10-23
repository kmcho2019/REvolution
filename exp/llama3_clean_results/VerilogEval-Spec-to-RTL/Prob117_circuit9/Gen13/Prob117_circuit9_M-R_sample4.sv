module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;

always @(posedge clk)
begin
    if (a)
        q <= 4;
    else if (q == 7)
        q <= 0;
    else
        q <= q + 1;
end

endmodule