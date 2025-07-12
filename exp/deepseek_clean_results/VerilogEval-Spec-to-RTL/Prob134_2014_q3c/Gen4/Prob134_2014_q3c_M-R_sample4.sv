module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state and output logic
    reg [2:0] Y;
    reg z_reg;
    
    always @(*) begin
        case ({y, x})
            // x=0 cases
            {3'b000, 1'b0}: begin Y = 3'b000; z_reg = 1'b0; end
            {3'b001, 1'b0}: begin Y = 3'b001; z_reg = 1'b0; end
            {3'b010, 1'b0}: begin Y = 3'b010; z_reg = 1'b0; end
            {3'b011, 1'b0}: begin Y = 3'b001; z_reg = 1'b1; end
            {3'b100, 1'b0}: begin Y = 3'b011; z_reg = 1'b1; end
            // x=1 cases
            {3'b000, 1'b1}: begin Y = 3'b001; z_reg = 1'b0; end
            {3'b001, 1'b1}: begin Y = 3'b100; z_reg = 1'b0; end
            {3'b010, 1'b1}: begin Y = 3'b001; z_reg = 1'b0; end
            {3'b011, 1'b1}: begin Y = 3'b010; z_reg = 1'b1; end
            {3'b100, 1'b1}: begin Y = 3'b100; z_reg = 1'b1; end
            // Default case (should never occur)
            default: begin Y = 3'b000; z_reg = 1'b0; end
        endcase
    end

    assign z = z_reg;
    assign Y0 = Y[0];

endmodule