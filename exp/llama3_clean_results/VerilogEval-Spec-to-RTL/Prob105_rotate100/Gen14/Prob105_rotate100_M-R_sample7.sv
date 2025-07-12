module TopModule(
    input               clk,
    input               load,
    input      [1:0]    ena,
    input      [99:0]   data,
    output reg [99:0]   q
);

// Combinational Logic for Rotation
wire [99:0] rotate_right = {q[0], q[99:1]};
wire [99:0] rotate_left = {q[98:0], q[99]};
wire [99:0] no_rotate = q;

// Next State Logic
wire [99:0] next_state;
assign next_state = (ena == 2'b01) ? rotate_right :
                    (ena == 2'b10) ? rotate_left :
                    no_rotate;

// Sequential Logic
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_state;
    end
end

endmodule