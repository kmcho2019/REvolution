module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

wire [99:0] rotate_left;
wire [99:0] rotate_right;

// Compute rotate left by 1: bits shifted left, MSB gets LSB
assign rotate_left = {q[98:0], q[99]};

// Compute rotate right by 1: bits shifted right, LSB gets MSB
assign rotate_right = {q[0], q[99:1]};

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        case (ena)
            2'b10: q <= rotate_left;  // rotate left
            2'b01: q <= rotate_right; // rotate right
            default: q <= q;          // no rotation
        endcase
    end
end

endmodule