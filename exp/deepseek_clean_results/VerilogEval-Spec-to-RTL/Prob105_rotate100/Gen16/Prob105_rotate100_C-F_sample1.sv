module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire rotate_left = (ena == 2'b10);
wire rotate_right = (ena == 2'b01);
wire [99:0] rotated_value = rotate_left ? {q[98:0], q[99]} : 
                           rotate_right ? {q[0], q[99:1]} : 
                           q;

always @(posedge clk) begin
    q <= load ? data : rotated_value;
end

endmodule