module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Precompute rotation directions for better readability
wire [99:0] rotated_left = {q[98:0], q[99]};
wire [99:0] rotated_right = {q[0], q[99:1]};

// Next state logic with clear priority
always @(*) begin
    if (load) begin
        q = data;  // Highest priority: synchronous load
    end else begin
        case (ena)
            2'b01: q = rotated_right;  // Right rotate
            2'b10: q = rotated_left;   // Left rotate
            default: q = q;            // No rotation (ena=00 or 11)
        endcase
    end
end

// Synchronous update
always @(posedge clk) begin
    q <= q;
end

endmodule