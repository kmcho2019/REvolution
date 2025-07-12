module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire clock_enable = load || (ena == 2'b01) || (ena == 2'b10);
wire clk_gated = clk & clock_enable;

wire [99:0] rotated_bits;
wire rotate_dir = (ena == 2'b10); // 1 for left, 0 for right

// Shared rotation logic
assign rotated_bits = rotate_dir ? {q[98:0], q[99]} : {q[0], q[99:1]};

always @(posedge clk_gated) begin
    if (load) begin
        q <= data;
    end else begin
        case (ena)
            2'b01, 2'b10: q <= rotated_bits;
            default: q <= q; // No change for 2'b00 and 2'b11
        endcase
    end
end

endmodule