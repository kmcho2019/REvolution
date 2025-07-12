module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire [99:0] next_q;

assign next_q = load ? data : 
                (ena == 2'b01) ? {q[0], q[99:1]} :  // Right rotate
                (ena == 2'b10) ? {q[98:0], q[99]} :  // Left rotate
                q;                                  // No rotation

always @(posedge clk) begin
    q <= next_q;
end

endmodule