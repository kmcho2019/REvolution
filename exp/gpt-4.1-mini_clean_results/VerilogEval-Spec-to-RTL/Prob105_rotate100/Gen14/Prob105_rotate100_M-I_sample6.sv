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
wire        update_en;

// Compute rotate left by 1: bits shifted left, MSB gets LSB
assign rotate_left  = {q[98:0], q[99]};

// Compute rotate right by 1: bits shifted right, LSB gets MSB
assign rotate_right = {q[0], q[99:1]};

// Determine if register update needed: load or ena == 01 or 10
assign update_en = load | (ena == 2'b01) | (ena == 2'b10);

always @(*) begin
    if (load) begin
        next_value = data;
    end else if (ena == 2'b10) begin
        next_value = rotate_left;
    end else if (ena == 2'b01) begin
        next_value = rotate_right;
    end else begin
        next_value = q; // hold current state
    end
end

always @(posedge clk) begin
    if (update_en)
        q <= next_value;
    else
        q <= q; // no update, reduces toggling
end

endmodule