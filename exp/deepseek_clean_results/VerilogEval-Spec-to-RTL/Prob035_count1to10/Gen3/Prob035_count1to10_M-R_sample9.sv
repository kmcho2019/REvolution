module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;
wire wrap = (q == 4'b1010);

assign next_q = reset ? 4'b0001 :    // Reset has highest priority
                wrap ? 4'b0001 :     // Wrap around to 1
                q + 1;               // Normal increment

always @(posedge clk) begin
    q <= next_q;
end

endmodule