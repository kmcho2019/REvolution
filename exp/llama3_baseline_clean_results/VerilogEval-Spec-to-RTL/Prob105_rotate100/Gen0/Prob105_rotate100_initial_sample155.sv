module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] rot_reg;

always @(posedge clk) begin
    if (load) begin
        rot_reg <= data;
    end else begin
        case (ena)
            2'b01: rot_reg <= {rot_reg[0], rot_reg[99:1]}; // rotate right
            2'b10: rot_reg <= {rot_reg[98:0], rot_reg[99]}; // rotate left
            default: rot_reg <= rot_reg; // no rotation
        endcase
    end
end

assign q = rot_reg;

endmodule