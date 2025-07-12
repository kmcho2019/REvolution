module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

assign q = q_reg;

// Barrel shifter for left rotation
wire [99:0] left_rotated;
assign left_rotated = {q_reg[98:0], q_reg[99]};

// Barrel shifter for right rotation
wire [99:0] right_rotated;
assign right_rotated = {q_reg[0], q_reg[99:1]};

// Multiplexer to select between rotated outputs and original input data
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        case (ena)
            2'b01: q_reg <= right_rotated; // Rotate right
            2'b10: q_reg <= left_rotated; // Rotate left
            default: q_reg <= q_reg; // No rotation
        endcase
    end
end

endmodule