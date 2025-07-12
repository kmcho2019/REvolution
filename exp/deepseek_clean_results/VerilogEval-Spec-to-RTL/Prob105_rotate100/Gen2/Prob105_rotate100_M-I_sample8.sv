module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire rotate_right = (ena == 2'b01);
wire rotate_left = (ena == 2'b10);
wire no_rotate = ~(rotate_right | rotate_left);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end
    else if (rotate_right) begin
        q <= {q[0], q[99:1]};  // Right rotate
    end
    else if (rotate_left) begin
        q <= {q[98:0], q[99]};  // Left rotate
    end
    // No else needed - q retains value when no_rotate
end

endmodule