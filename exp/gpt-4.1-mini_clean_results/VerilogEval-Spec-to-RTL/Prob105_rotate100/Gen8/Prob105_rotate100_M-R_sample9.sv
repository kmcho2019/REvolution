module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire [99:0] rotate_left;
wire [99:0] rotate_right;
wire [99:0] rotate_val;

// Compute rotate left and rotate right values combinationally
assign rotate_left  = {q[98:0], q[99]};
assign rotate_right = {q[0], q[99:1]};

// Select rotation based on ena
assign rotate_val = (ena == 2'b10) ? rotate_left :
                    (ena == 2'b01) ? rotate_right :
                    q;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= rotate_val;
    end
end

endmodule