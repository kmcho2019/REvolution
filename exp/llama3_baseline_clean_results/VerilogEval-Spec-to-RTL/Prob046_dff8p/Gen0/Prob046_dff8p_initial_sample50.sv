module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q;

always @(posedge reset or negedge clk)
begin
    if (reset)
        q <= 8'd52; // 0x34 in decimal is 52
    else
        q <= d;
end

endmodule