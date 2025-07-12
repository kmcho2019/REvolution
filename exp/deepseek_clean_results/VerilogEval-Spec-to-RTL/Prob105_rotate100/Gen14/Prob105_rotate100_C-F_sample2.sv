module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire [99:0] rotated_left = {q[98:0], q[99]};
wire [99:0] rotated_right = {q[0], q[99:1]};

always @(posedge clk) begin
    q <= load ? data :
         (ena == 2'b10) ? rotated_left :
         (ena == 2'b01) ? rotated_right :
         q;
end

endmodule