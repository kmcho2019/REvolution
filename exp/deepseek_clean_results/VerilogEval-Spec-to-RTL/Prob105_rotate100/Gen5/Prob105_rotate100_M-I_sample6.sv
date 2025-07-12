module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire do_rotate = (ena == 2'b01) || (ena == 2'b10);
wire rotate_dir = (ena == 2'b10); // 1 for left, 0 for right
wire [99:0] rotated_data;

// Shared rotation logic
assign rotated_data = rotate_dir ? {q[98:0], q[99]} : {q[0], q[99:1]};

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end
    else if (do_rotate) begin
        q <= rotated_data;
    end
    // else hold value (implicit)
end

endmodule