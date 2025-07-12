module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire do_rotate_left = (ena == 2'b10);
wire do_rotate_right = (ena == 2'b01);

wire [99:0] rotated_left = {q[98:0], q[99]};
wire [99:0] rotated_right = {q[0], q[99:1]};
wire [99:0] next_q = load ? data :
                     do_rotate_left ? rotated_left :
                     do_rotate_right ? rotated_right :
                     q;

always @(posedge clk) begin
    q <= next_q;
end

endmodule