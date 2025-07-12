module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    wire [99:0] rotate_left;
    wire [99:0] rotate_right;
    wire update_en;

    // One-bit left rotation: q[i] = q[i+1], MSB wraps around to LSB
    assign rotate_left[98:0] = q[99:1];
    assign rotate_left[99]   = q[0];

    // One-bit right rotation: q[i] = q[i-1], LSB wraps around to MSB
    assign rotate_right[1:99] = q[0:98];
    assign rotate_right[0]    = q[99];

    // Update enable: only update when load or ena enables rotation
    assign update_en = load | (ena == 2'b01) | (ena == 2'b10);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (update_en) begin
            case (ena)
                2'b01: q <= rotate_right;  // Rotate right by one bit
                2'b10: q <= rotate_left;   // Rotate left by one bit
                default: q <= q;           // No change (redundant here)
            endcase
        end
        // else q holds value, no toggle (no unnecessary write)
    end

endmodule