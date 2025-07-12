module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;
wire wrap_around = q[3] & ~q[2] & q[1];  // Efficient detection of 10 (1010)

assign next_q = reset ? 4'b0001 :        // Reset condition
                wrap_around ? 4'b0001 :   // Wrap-around condition
                q + 1;                    // Normal increment

always @(posedge clk) begin
    q <= next_q;                          // Register the next state
end

endmodule