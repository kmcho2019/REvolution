module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Precompute rotated versions
wire [99:0] right_rotated = {q[0], q[99:1]};
wire [99:0] left_rotated = {q[98:0], q[99]};

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        case (ena)
            2'b01: q <= right_rotated;  // Right rotate
            2'b10: q <= left_rotated;   // Left rotate
            default: q <= q;            // No rotate
        endcase
    end
end

endmodule