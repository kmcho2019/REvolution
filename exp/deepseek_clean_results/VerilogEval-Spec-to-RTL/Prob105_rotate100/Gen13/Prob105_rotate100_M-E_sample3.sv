module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Pre-compute rotation values
wire [99:0] right_rot = {q[0], q[99:1]};  // Right rotate
wire [99:0] left_rot = {q[98:0], q[99]};  // Left rotate

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        case (ena)
            2'b01: q <= right_rot;
            2'b10: q <= left_rot;
            default: q <= q;  // No rotation
        endcase
    end
end

endmodule