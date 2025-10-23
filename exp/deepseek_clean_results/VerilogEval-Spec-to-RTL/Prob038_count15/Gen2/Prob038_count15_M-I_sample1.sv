module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;
wire carry_gate;

// Carry-lookahead logic for faster increment
assign next_q[0] = ~q[0];
assign next_q[1] = q[1] ^ q[0];
assign next_q[2] = q[2] ^ (q[1] & q[0]);
assign next_q[3] = q[3] ^ (q[2] & q[1] & q[0]);

// Clock gating when counter reaches 15
assign carry_gate = ~(&q);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else if (carry_gate) begin
        q <= next_q;
    end
    // else hold at 15 (clock gated)
end

endmodule