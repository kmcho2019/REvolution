module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire [99:0] next_q;
wire [99:0] right_rotated = {q[0], q[99:1]};
wire [99:0] left_rotated = {q[98:0], q[99]};

assign next_q = load ? data : 
               (ena == 2'b01) ? right_rotated :
               (ena == 2'b10) ? left_rotated :
               q;

always @(posedge clk) begin
    q <= next_q;
end

endmodule