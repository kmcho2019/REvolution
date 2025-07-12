module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

wire rotate_enable = load | (ena == 2'b01) | (ena == 2'b10);
reg [99:0] rotate_left, rotate_right;
reg [99:0] next_value;

always @* begin
    // Compute rotate left only if needed
    rotate_left = {q[98:0], q[99]};
    // Compute rotate right only if needed
    rotate_right = {q[0], q[99:1]};

    case (1'b1)
        load:       next_value = data;
        (ena == 2'b10): next_value = rotate_left;
        (ena == 2'b01): next_value = rotate_right;
        default:    next_value = q;
    endcase
end

always @(posedge clk) begin
    if (rotate_enable) begin
        q <= next_value;
    end
end

endmodule