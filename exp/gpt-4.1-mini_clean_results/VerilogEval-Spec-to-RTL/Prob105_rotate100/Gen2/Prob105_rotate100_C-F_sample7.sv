module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

reg [99:0] next_q;
wire rotate_enable;

// Rotation enable is true if ena indicates rotate left or rotate right
assign rotate_enable = (ena == 2'b01) || (ena == 2'b10);

always @* begin
    if (load) begin
        // Synchronously load input data on next clock edge
        next_q = data;
    end else begin
        case (ena)
            2'b01: next_q = {q[0], q[99:1]};  // Rotate right by one bit
            2'b10: next_q = {q[98:0], q[99]}; // Rotate left by one bit
            default: next_q = q;               // Hold current value
        endcase
    end
end

always @(posedge clk) begin
    // Update q only when loading or rotating to reduce unnecessary toggling
    if (load || rotate_enable)
        q <= next_q;
    else
        q <= q;
end

endmodule