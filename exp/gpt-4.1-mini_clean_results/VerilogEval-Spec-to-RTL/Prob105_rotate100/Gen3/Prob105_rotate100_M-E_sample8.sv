module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

wire [99:0] rotate_left;
wire [99:0] rotate_right;

// Compute left rotation: q[98:0] shifted left, MSB replaced by q[99]
assign rotate_left = {q[98:0], q[99]};

// Compute right rotation: q[0] becomes MSB, rest shifted right
assign rotate_right = {q[0], q[99:1]};

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (ena == 2'b10) begin
        q <= rotate_left;
    end else if (ena == 2'b01) begin
        q <= rotate_right;
    end else begin
        q <= q;
    end
end

endmodule