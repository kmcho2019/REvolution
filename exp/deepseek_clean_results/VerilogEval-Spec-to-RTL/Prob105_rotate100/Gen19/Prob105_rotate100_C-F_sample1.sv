module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Pre-compute both rotation directions
wire [99:0] rotated_left = {q[98:0], q[99]};
wire [99:0] rotated_right = {q[0], q[99:1]};

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end
    else begin
        case (ena)
            2'b01: q <= rotated_right;    // Right rotate
            2'b10: q <= rotated_left;     // Left rotate
            default: q <= q;              // No rotation
        endcase
    end
end

endmodule