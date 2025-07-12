module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

wire update_enable;
wire [99:0] rotate_left;
wire [99:0] rotate_right;
reg  [99:0] next_value;

// Generate update enable when loading or rotating
assign update_enable = load | (ena == 2'b01) | (ena == 2'b10);

// Compute rotate left only if ena == 2'b10, else keep q (to reduce toggling)
assign rotate_left  = (ena == 2'b10) ? {q[98:0], q[99]} : q;

// Compute rotate right only if ena == 2'b01, else keep q
assign rotate_right = (ena == 2'b01) ? {q[0], q[99:1]} : q;

// Use case to select next value
always @(*) begin
    if (load) begin
        next_value = data;
    end else begin
        case (ena)
            2'b10: next_value = rotate_left;
            2'b01: next_value = rotate_right;
            default: next_value = q;
        endcase
    end
end

// Update register only when update_enable is asserted
always @(posedge clk) begin
    if (update_enable)
        q <= next_value;
end

endmodule