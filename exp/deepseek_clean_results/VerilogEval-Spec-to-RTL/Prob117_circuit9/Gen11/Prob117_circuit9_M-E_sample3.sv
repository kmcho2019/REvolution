module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [2:0] next_q;

// Carry lookahead logic for fast increment
wire [2:0] carry;
assign carry[0] = 1'b1;  // Always increment by 1
assign carry[1] = q[0] & carry[0];
assign carry[2] = q[1] & carry[1];

// Next state logic
assign next_q[0] = a ? 1'b0 : q[0] ^ carry[0];
assign next_q[1] = a ? 1'b0 : q[1] ^ carry[1];
assign next_q[2] = a ? 1'b1 : (q[2] ^ carry[2]) & ~(q == 3'd6);  // Wrap-around at 6

always @(posedge clk) begin
    q <= next_q;
end

endmodule