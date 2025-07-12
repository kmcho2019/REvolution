module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire do_rotate = (ena == 2'b01) || (ena == 2'b10);
wire rotate_dir = (ena == 2'b10); // 1=left, 0=right
wire [99:0] rotated_data;

// Shared rotation logic
assign rotated_data = rotate_dir ? {q[98:0], q[99]} :  // left rotate
                                 {q[0], q[99:1]};     // right rotate

// Next state logic with enable gating
wire [99:0] next_q = load ? data : 
                    (do_rotate ? rotated_data : q);

always @(posedge clk) begin
    q <= next_q;
end

endmodule