module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    reg [2:0] next_state;
    reg next_z;

    always @(*) begin
        case (y)
            3'b000: {next_state, next_z} = x ? {3'b001, 1'b0} : {3'b000, 1'b0};
            3'b001: {next_state, next_z} = x ? {3'b100, 1'b0} : {3'b001, 1'b0};
            3'b010: {next_state, next_z} = x ? {3'b001, 1'b0} : {3'b010, 1'b0};
            3'b011: {next_state, next_z} = x ? {3'b010, 1'b1} : {3'b001, 1'b1};
            3'b100: {next_state, next_z} = x ? {3'b100, 1'b1} : {3'b011, 1'b1};
            default: {next_state, next_z} = {3'b000, 1'b0};
        endcase
    end

    assign z = next_z;
    assign Y0 = next_state[0];

endmodule