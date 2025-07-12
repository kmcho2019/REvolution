module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Internal signals
wire rotate_en = |ena;  // Rotation enable (any non-zero ena)
wire rotate_dir = ena[1]; // 0=right, 1=left
wire [99:0] rotated_data;

// Unified barrel rotation logic
assign rotated_data = rotate_dir ? 
                     {q[98:0], q[99]} :  // Left rotate
                     {q[0], q[99:1]};    // Right rotate

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end
    else if (rotate_en) begin
        q <= rotated_data;
    end
    // else: implicit hold (clock gated by synthesis)
end

endmodule