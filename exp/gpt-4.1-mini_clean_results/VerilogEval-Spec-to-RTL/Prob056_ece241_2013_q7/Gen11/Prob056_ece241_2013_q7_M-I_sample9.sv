module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire nextQ = (j & ~Q) | (~k & Q);
wire enable = j | k;  // only update when J or K is asserted

always @(posedge clk) begin
    if (enable)
        Q <= nextQ;
end

endmodule