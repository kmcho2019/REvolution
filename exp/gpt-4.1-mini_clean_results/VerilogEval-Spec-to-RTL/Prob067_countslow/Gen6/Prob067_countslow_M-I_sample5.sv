module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

wire wrap;
wire [3:0] q_next;

// Optimized wrap detection: q == 4'b1001 (decimal 9)
assign wrap = (q[3] & ~q[2] & ~q[1] & q[0]);
// Next state: wrap around to 0 else increment
assign q_next = wrap ? 4'd0 : (q + 4'd1);

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else if (slowena)
        q <= q_next;
end

endmodule