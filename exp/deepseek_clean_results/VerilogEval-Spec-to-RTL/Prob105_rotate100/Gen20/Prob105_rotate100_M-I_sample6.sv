module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Segment the 100-bit register into 4x25-bit segments
wire [24:0] seg0, seg1, seg2, seg3;
assign {seg3, seg2, seg1, seg0} = q;

// Pipeline register for rotation operations
reg [99:0] rotated_q;

always @(*) begin
    case (ena)
        2'b01: rotated_q = {q[0], q[99:1]};    // Right rotate
        2'b10: rotated_q = {q[98:0], q[99]};   // Left rotate
        default: rotated_q = q;                // No rotation
    endcase
end

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end
    else if (ena != 2'b00 && ena != 2'b11) begin
        q <= rotated_q;
    end
end

endmodule