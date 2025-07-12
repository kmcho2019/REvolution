module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q;

always @(negedge clk) begin
    if (reset) begin
        q <= 8'd52; // Reset value is 0x34 (52 in decimal)
    end else begin
        q <= d;
    end
end

endmodule