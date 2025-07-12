module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Pre-calculate rotated values
wire [99:0] rotated_left;
wire [99:0] rotated_right;

assign rotated_left = {q[98:0], q[99]};
assign rotated_right = {q[0], q[99:1]};

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        case (ena)
            2'b01: q <= rotated_right; // Rotate right by one bit
            2'b10: q <= rotated_left; // Rotate left by one bit
            default: q <= q; // No rotation
        endcase
    end
end

endmodule