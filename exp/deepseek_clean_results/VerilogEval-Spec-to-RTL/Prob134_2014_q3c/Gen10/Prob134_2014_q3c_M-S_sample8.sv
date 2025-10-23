module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    reg Y0_reg, z_reg;

    always @(*) begin
        case (y)
            3'b000: begin Y0_reg = x ? 1'b1 : 1'b0; z_reg = 1'b0; end
            3'b001: begin Y0_reg = x ? 1'b0 : 1'b1; z_reg = 1'b0; end
            3'b010: begin Y0_reg = x ? 1'b1 : 1'b0; z_reg = 1'b0; end
            3'b011: begin Y0_reg = x ? 1'b0 : 1'b1; z_reg = 1'b1; end
            3'b100: begin Y0_reg = x ? 1'b0 : 1'b1; z_reg = 1'b1; end
            default: begin Y0_reg = 1'b0; z_reg = 1'b0; end
        endcase
    end

    assign Y0 = Y0_reg;
    assign z = z_reg;

endmodule