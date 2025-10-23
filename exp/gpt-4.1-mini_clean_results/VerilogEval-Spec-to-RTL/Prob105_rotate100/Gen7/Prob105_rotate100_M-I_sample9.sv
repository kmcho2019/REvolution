module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

wire [99:0] rotate_left;
wire [99:0] rotate_right;
reg  [99:0] next_value;
wire        reg_enable;

// Compute rotate left by 1: bits shifted left, MSB gets LSB
assign rotate_left  = {q[98:0], q[99]};
// Compute rotate right by 1: bits shifted right, LSB gets MSB
assign rotate_right = {q[0], q[99]};

// Enable register update only if load is high or ena indicates rotation (01 or 10)
assign reg_enable = load | (ena == 2'b01) | (ena == 2'b10);

always @(*) begin
    if (load) begin
        next_value = data;
    end else begin
        case (ena)
            2'b01: next_value = rotate_right;
            2'b10: next_value = rotate_left;
            default: next_value = q; // No rotation
        endcase
    end
end

always @(posedge clk) begin
    if (reg_enable)
        q <= next_value;
end

endmodule