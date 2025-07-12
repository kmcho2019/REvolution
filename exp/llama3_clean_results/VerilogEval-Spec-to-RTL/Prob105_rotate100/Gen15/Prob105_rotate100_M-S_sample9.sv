module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;
assign q = q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        case (ena)
            2'b01: q_reg <= {q_reg[0], q_reg[99:1]}; // Rotate Right
            2'b10: q_reg <= {q_reg[98:0], q_reg[99]}; // Rotate Left
            default: q_reg <= q_reg; // No Rotation
        endcase
    end
end

endmodule