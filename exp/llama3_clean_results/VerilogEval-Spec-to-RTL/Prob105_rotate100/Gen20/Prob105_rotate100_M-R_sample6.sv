module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;
assign q = q_reg;

wire [99:0] next_q;

// Combinational logic for rotation operations
always @(*) begin
    case (ena)
        2'b01: next_q = {q_reg[0], q_reg[99:1]}; // Rotate right
        2'b10: next_q = {q_reg[98:0], q_reg[99]}; // Rotate left
        default: next_q = q_reg; // No rotation
    endcase
end

// Update q_reg on clock edge
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_q;
    end
end

endmodule