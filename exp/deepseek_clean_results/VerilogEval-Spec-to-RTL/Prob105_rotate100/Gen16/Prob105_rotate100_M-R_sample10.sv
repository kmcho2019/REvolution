module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire [99:0] q_next;

// Combinational logic for next state
assign q_next = load ? data : 
                (ena == 2'b01) ? {q[0], q[99:1]} :  // Right rotate
                (ena == 2'b10) ? {q[98:0], q[99]} : // Left rotate
                q;                                  // No rotate

// Sequential logic for register update
always @(posedge clk) begin
    q <= q_next;
end

endmodule