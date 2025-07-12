module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

// D flip-flop with synchronous reset
module DFF (
    input clk,
    input reset,
    input d,
    output reg q
);
always @(posedge clk) begin
    if (reset) q <= 1'b0;
    else q <= d;
end
endmodule

// Next state logic
wire [3:0] next_count;
assign next_count[0] = ~q[0];
assign next_count[1] = q[0] ? ~q[1] : q[1];
assign next_count[2] = (q[1] & q[0]) ? ~q[2] : q[2];
assign next_count[3] = (q[2] & q[1] & q[0]) ? ~q[3] : q[3];

// Instantiate DFFs for each bit
DFF bit0 (.clk(clk), .reset(reset), .d(next_count[0]), .q(q[0]));
DFF bit1 (.clk(clk), .reset(reset), .d(next_count[1]), .q(q[1]));
DFF bit2 (.clk(clk), .reset(reset), .d(next_count[2]), .q(q[2]));
DFF bit3 (.clk(clk), .reset(reset), .d(next_count[3]), .q(q[3]));

endmodule