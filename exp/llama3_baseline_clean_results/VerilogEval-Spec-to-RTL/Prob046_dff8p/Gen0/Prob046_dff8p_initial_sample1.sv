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
        q <= 8'h34;
    else
        q <= d;
end

endmodule