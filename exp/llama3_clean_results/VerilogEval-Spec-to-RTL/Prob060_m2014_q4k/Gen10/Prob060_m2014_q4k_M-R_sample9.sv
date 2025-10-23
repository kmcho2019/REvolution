// D Flip-Flop Module with Active-Low Synchronous Reset
module DFF(
    input clk,
    input resetn,
    input d,
    output reg q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule

// TopModule with Shift Register
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] q;

DFF u_dff0 (.clk(clk), .resetn(resetn), .d(in), .q(q[0]));
DFF u_dff1 (.clk(clk), .resetn(resetn), .d(q[0]), .q(q[1]));
DFF u_dff2 (.clk(clk), .resetn(resetn), .d(q[1]), .q(q[2]));
DFF u_dff3 (.clk(clk), .resetn(resetn), .d(q[2]), .q(q[3]));

assign out = q[3];

endmodule