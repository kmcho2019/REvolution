module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 8'h34; // reset value
    end else if (~clk) begin // clk is not a standard signal name for a clock
        // the always block is triggered by the positive edge of clk in verilog
        // so we must use the inverse of clk to trigger on the negative edge
        q <= d;
    end
end

endmodule