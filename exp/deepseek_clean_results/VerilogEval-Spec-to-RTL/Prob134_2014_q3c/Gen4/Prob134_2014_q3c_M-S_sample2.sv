module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    reg [2:0] next_state;
    reg z_reg;

    always @(*) begin
        case (y)
            3'b000: {next_state, z_reg} = x ? {3'b001, 1'b0} : {3'b000, 1'b0};
            3'b001: {next_state, z_reg} = x ? {3'b100, 1'b0} : {3'b001, 1'b0};
            3'b010: {next_state, z_reg} = x ? {3'b001, 1'b0} : {3'b010, 1'b0};
            3'b011: {next_state, z_reg} = x ? {3'b010, 1'b1} : {3'b001, 1'b1};
            3'b100: {next_state, z_reg} = x ? {3'b100, 1'b1} : {3'b011, 1'b1};
            default: {next_state, z_reg} = {3'b000, 1'b0};
        endcase
    end

    assign Y0 = next_state[0];
    assign z = z_reg;

endmodule