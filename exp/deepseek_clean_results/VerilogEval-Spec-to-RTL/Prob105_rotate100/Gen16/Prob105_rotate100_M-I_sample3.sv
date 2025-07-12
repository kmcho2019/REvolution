module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire rotate_en = |ena;  // Rotation enable (ena != 2'b00)
wire [99:0] next_q;

// Rotation computation (combinational)
assign next_q = (ena == 2'b01) ? {q[0], q[99:1]} :  // Right rotate
                (ena == 2'b10) ? {q[98:0], q[99]} : // Left rotate
                q;                                  // No rotation

always @(posedge clk) begin
    if (load) begin
        q <= data;  // Synchronous load has highest priority
    end else if (rotate_en) begin
        q <= next_q; // Only update if rotation is enabled
    end
    // Implicit else: q holds its value (no power-consuming update)
end

endmodule