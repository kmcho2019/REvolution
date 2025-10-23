module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    reg [2:0] Y;
    reg z_out;

    always @(*) begin
        case (y)
            3'b000: {Y, z_out} = x ? {3'b001, 1'b0} : {3'b000, 1'b0};
            3'b001: {Y, z_out} = x ? {3'b100, 1'b0} : {3'b001, 1'b0};
            3'b010: {Y, z_out} = x ? {3'b001, 1'b0} : {3'b010, 1'b0};
            3'b011: {Y, z_out} = x ? {3'b010, 1'b1} : {3'b001, 1'b1};
            3'b100: {Y, z_out} = x ? {3'b100, 1'b1} : {3'b011, 1'b1};
            default: {Y, z_out} = {3'b000, 1'b0}; // Safe default
        endcase
    end

    assign Y0 = Y[0];
    assign z = z_out;

endmodule