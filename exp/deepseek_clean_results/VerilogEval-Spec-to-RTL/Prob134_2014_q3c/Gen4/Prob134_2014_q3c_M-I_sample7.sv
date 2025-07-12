module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    reg [2:0] Y;
    reg z_reg;

    always @(*) begin
        case ({y, x})
            // x = 0 cases
            4'b0000: begin Y = 3'b000; z_reg = 1'b0; end
            4'b0010: begin Y = 3'b001; z_reg = 1'b0; end
            4'b0100: begin Y = 3'b010; z_reg = 1'b0; end
            4'b0110: begin Y = 3'b001; z_reg = 1'b1; end
            4'b1000: begin Y = 3'b011; z_reg = 1'b1; end
            // x = 1 cases
            4'b0001: begin Y = 3'b001; z_reg = 1'b0; end
            4'b0011: begin Y = 3'b100; z_reg = 1'b0; end
            4'b0101: begin Y = 3'b001; z_reg = 1'b0; end
            4'b0111: begin Y = 3'b010; z_reg = 1'b1; end
            4'b1001: begin Y = 3'b100; z_reg = 1'b1; end
            // Default case (should never occur)
            default: begin Y = 3'b000; z_reg = 1'b0; end
        endcase
    end

    assign z = z_reg;
    assign Y0 = Y[0];

endmodule