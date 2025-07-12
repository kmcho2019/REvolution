module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a)
        q <= 3'b100;  // hold at 4 when a=1
    else
        q <= (q == 3'b110) ? 3'b000 : q + 1;  // increment and wrap at 6
end

endmodule