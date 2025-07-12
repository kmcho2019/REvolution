module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

assign q = q_reg;

// Single wire to represent the rotated output
wire [99:0] rotated;
assign rotated = (ena == 2'b01) ? {q_reg[0], q_reg[99:1]} : // Rotate right
                 (ena == 2'b10) ? {q_reg[98:0], q_reg[99]} : // Rotate left
                 q_reg; // No rotation

// Clock gating to reduce unnecessary switching activity
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (ena != 2'b00 && ena != 2'b11) begin
        q_reg <= rotated;
    end
end

endmodule