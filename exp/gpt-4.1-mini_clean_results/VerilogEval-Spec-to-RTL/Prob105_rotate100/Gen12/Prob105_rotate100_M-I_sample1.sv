module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] next_q;

    wire rotate_right = (ena == 2'b01);
    wire rotate_left  = (ena == 2'b10);
    wire active_rotate = rotate_right | rotate_left;
    wire update_enable = load | active_rotate;

    // Rotate left by 1 using barrel-shift logic:
    // q[99:0] rotated left by 1 = {q[98:0], q[99]}
    // Rotate right by 1: {q[0], q[99:1]}
    // Break rotation into smaller concatenations to reduce logic depth.

    wire [49:0] left_half  = q[99:50];
    wire [49:0] right_half = q[49:0];

    wire [49:0] rotate_left_upper = {left_half[48:0], right_half[49]};
    wire [49:0] rotate_left_lower = {right_half[48:0], left_half[49]};

    wire [49:0] rotate_right_upper = {right_half[0], left_half[49:1]};
    wire [49:0] rotate_right_lower = {left_half[0], right_half[49:1]};

    // Reconstruct q after rotation:
    wire [99:0] rotated_left  = {rotate_left_upper, rotate_left_lower};
    wire [99:0] rotated_right = {rotate_right_upper, rotate_right_lower};

    always @* begin
        if (load) begin
            next_q = data;
        end else if (rotate_right) begin
            next_q = rotated_right;
        end else if (rotate_left) begin
            next_q = rotated_left;
        end else begin
            next_q = q;
        end
    end

    // Update register only on clock; power optimization by gating data flow not needed here
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule