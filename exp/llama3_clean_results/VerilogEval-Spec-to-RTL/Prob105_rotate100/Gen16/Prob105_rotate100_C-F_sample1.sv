module TopModule(
    input               clk,
    input               load,
    input      [1:0]    ena,
    input      [99:0]   data,
    output reg [99:0]   q
);

// Rotation Logic
wire [99:0] rotate_right = {q[0], q[99:1]};
wire [99:0] rotate_left = {q[98:0], q[99]};
wire [99:0] no_rotate = q;

// Sequential Logic
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        case (ena)
            2'b01: q <= rotate_right; // Rotate right by one bit
            2'b10: q <= rotate_left;  // Rotate left by one bit
            default: q <= no_rotate;  // No rotation
        endcase
    end
end

endmodule