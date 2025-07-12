module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;
reg [99:0] q_next;

// Output Logic
assign q = q_reg;

// Combinational Logic
always @(*) begin
    case (ena)
        2'b01: q_next = {q_reg[0], q_reg[99:1]}; // Rotate right
        2'b10: q_next = {q_reg[98:0], q_reg[99]}; // Rotate left
        default: q_next = q_reg; // No rotation
    endcase
end

// Sequential Logic
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (ena != 2'b00 && ena != 2'b11) begin // Rotate if enabled
        q_reg <= q_next;
    end
end

endmodule