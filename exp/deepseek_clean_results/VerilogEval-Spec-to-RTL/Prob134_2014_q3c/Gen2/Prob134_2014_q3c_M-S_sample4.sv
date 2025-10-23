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
        case (y)
            3'b000: {Y, z_reg} = x ? {3'b001, 1'b0} : {3'b000, 1'b0};
            3'b001: {Y, z_reg} = x ? {3'b100, 1'b0} : {3'b001, 1'b0};
            3'b010: {Y, z_reg} = x ? {3'b001, 1'b0} : {3'b010, 1'b0};
            3'b011: {Y, z_reg} = x ? {3'b010, 1'b1} : {3'b001, 1'b1};
            3'b100: {Y, z_reg} = x ? {3'b100, 1'b1} : {3'b011, 1'b1};
            default: {Y, z_reg} = {3'b000, 1'b0}; // Should never occur
        endcase
    end

    assign Y0 = Y[0];
    assign z = z_reg;

endmodule