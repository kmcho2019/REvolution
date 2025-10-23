module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

// Next state logic
wire [3:0] next_q = reset ? 4'b0 : 
                   (q[3] & q[0]) ? 4'b0 : 
                   q + 1'b1;

// D flip-flops for each bit
dff dff0 (.clk(clk), .d(next_q[0]), .q(q[0]));
dff dff1 (.clk(clk), .d(next_q[1]), .q(q[1]));
dff dff2 (.clk(clk), .d(next_q[2]), .q(q[2]));
dff dff3 (.clk(clk), .d(next_q[3]), .q(q[3]));

endmodule

// Basic D flip-flop module
module dff (
    input clk,
    input d,
    output reg q
);
always @(posedge clk) begin
    q <= d;
end
endmodule