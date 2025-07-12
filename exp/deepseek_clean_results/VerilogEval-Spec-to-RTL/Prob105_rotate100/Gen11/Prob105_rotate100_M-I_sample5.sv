module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Pre-compute both rotation directions
wire [99:0] right_rot = {q[0], q[99:1]};
wire [99:0] left_rot = {q[98:0], q[99]};

always @(posedge clk) begin
    if (load) begin
        q <= data;  // Highest priority: synchronous load
    end else if (ena == 2'b01) begin
        q <= right_rot;  // Right rotate
    end else if (ena == 2'b10) begin
        q <= left_rot;   // Left rotate
    end
    // else maintain value (implicit)
end

endmodule