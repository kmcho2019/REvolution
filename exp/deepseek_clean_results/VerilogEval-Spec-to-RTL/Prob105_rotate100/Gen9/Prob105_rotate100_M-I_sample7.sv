module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire [99:0] next_q;
wire rotation_en = |ena; // Enable when any rotation is needed

assign next_q = load ? data : 
               (ena == 2'b01) ? {q[0], q[99:1]} : // Right rotate
               (ena == 2'b10) ? {q[98:0], q[99]} : // Left rotate
               q;

always @(posedge clk) begin
    if (load || rotation_en) begin
        q <= next_q;
    end
    // Else retain value (implicit)
end

endmodule