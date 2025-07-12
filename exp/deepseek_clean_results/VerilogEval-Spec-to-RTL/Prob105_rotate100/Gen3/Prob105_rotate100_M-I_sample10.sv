module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// One-hot encoded control signals
wire rotate_right = (ena == 2'b01);
wire rotate_left  = (ena == 2'b10);
wire no_rotate    = (ena == 2'b00) || (ena == 2'b11);

// Clock gating logic
wire clk_en = load || rotate_right || rotate_left;
wire gated_clk;
assign gated_clk = clk_en ? clk : 1'b0;

// Unified rotation logic
wire [99:0] next_q;
assign next_q = load ? data : 
               rotate_right ? {q[0], q[99:1]} :
               rotate_left  ? {q[98:0], q[99]} :
               q;

always @(posedge gated_clk) begin
    q <= next_q;
end

endmodule