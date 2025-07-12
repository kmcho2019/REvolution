module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

// Rotation logic
wire [99:0] next_q = load ? data :
                    (ena == 2'b10) ? {q_reg[98:0], q_reg[99]} :  // left rotate
                    (ena == 2'b01) ? {q_reg[0], q_reg[99:1]} :    // right rotate
                    q_reg;

// Register update
always @(posedge clk) begin
    q_reg <= next_q;
end

// Output assignment
assign q = q_reg;

endmodule