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
        q <= data;
    end else begin
        case (ena)
            2'b01: q <= right_rot;  // Right rotate
            2'b10: q <= left_rot;   // Left rotate
            default: q <= q;        // No rotation
        endcase
    end
end

endmodule