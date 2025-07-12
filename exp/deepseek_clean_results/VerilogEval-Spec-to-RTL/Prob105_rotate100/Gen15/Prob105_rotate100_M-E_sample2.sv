module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Pre-compute all rotation patterns
wire [99:0] rotated_left = {q[98:0], q[99]};
wire [99:0] rotated_right = {q[0], q[99:1]};

// Unified rotation selection
wire [99:0] rotated_q = (ena == 2'b01) ? rotated_right :
                       (ena == 2'b10) ? rotated_left :
                       q;

// Next state logic
always @(posedge clk) begin
    q <= load ? data : rotated_q;
end

endmodule