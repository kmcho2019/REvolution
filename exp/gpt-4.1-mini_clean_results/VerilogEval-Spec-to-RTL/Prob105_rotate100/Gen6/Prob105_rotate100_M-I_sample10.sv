module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    // Internal wire for rotated versions
    wire [99:0] rot_left, rot_right;
    wire update_en;

    // Rotate left by 1: MSB wraps to LSB
    assign rot_left = {q[98:0], q[99]};
    // Rotate right by 1: LSB wraps to MSB
    assign rot_right = {q[0], q[99:1]};

    // Enable update only if load or a single-bit rotation requested
    assign update_en = load | (ena == 2'b01) | (ena == 2'b10);

    always @(posedge clk) begin
        if (update_en) begin
            if (load) begin
                q <= data;
            end else begin
                case (ena)
                    2'b01: q <= rot_right; // rotate right
                    2'b10: q <= rot_left;  // rotate left
                    default: q <= q;       // hold (covered by update_en logic, but safe)
                endcase
            end
        end
        // else hold q without assignment to avoid unnecessary toggling
    end

endmodule