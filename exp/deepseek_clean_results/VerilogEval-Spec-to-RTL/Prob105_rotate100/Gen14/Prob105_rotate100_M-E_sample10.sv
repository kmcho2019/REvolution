module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Rotation pattern selection
wire [1:0] rot_sel = (ena == 2'b01) ? 2'b01 :  // Right rotate
                     (ena == 2'b10) ? 2'b10 :  // Left rotate
                     2'b00;                    // No rotate

// Barrel shifter implementation
wire [99:0] rotated;
assign rotated = (rot_sel == 2'b01) ? {q[0], q[99:1]} :  // Right
                 (rot_sel == 2'b10) ? {q[98:0], q[99]} :  // Left
                 q;                                       // No change

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= rotated;
    end
end

endmodule