module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;
wire clk_gated;

// Clock gating: only enable clock when load is high or ena is not 2'b00 or 2'b11
assign clk_gated = (load || (ena != 2'b00 && ena != 2'b11)) ? clk : 1'b0;

always @(posedge clk_gated) begin
    if (load) begin
        q_reg <= data;
    end else begin
        case (ena)
            2'b01: q_reg <= {q_reg[0], q_reg[99:1]}; // Rotate right by one bit
            2'b10: q_reg <= {q_reg[98:0], q_reg[99]}; // Rotate left by one bit
            default: q_reg <= q_reg; // No rotation
        endcase
    end
end

assign q = q_reg;

endmodule