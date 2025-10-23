module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire ce = (q != 4'd9);               // Enable counting only if q < 9
wire [3:0] next_q = q + 4'd1;       // Next count when enabled

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;                   // Synchronous active-high reset
    else if (ce)
        q <= next_q;                 // Increment when enabled
    else if (q == 4'd9)
        q <= 4'd0;                  // Wrap around to zero after 9
    // else retain q (no else branch needed because q remains stable)
end

endmodule