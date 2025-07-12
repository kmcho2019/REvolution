module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    reg [3:0] next_state_z; // {next_state[2:0], z}

    always @(*) begin
        case ({y, x})
            // x = 0 cases
            4'b000_0: next_state_z = {3'b000, 1'b0};
            4'b001_0: next_state_z = {3'b001, 1'b0};
            4'b010_0: next_state_z = {3'b010, 1'b0};
            4'b011_0: next_state_z = {3'b001, 1'b1};
            4'b100_0: next_state_z = {3'b011, 1'b1};
            // x = 1 cases
            4'b000_1: next_state_z = {3'b001, 1'b0};
            4'b001_1: next_state_z = {3'b100, 1'b0};
            4'b010_1: next_state_z = {3'b001, 1'b0};
            4'b011_1: next_state_z = {3'b010, 1'b1};
            4'b100_1: next_state_z = {3'b100, 1'b1};
            // default case (should never occur)
            default:  next_state_z = {3'b000, 1'b0};
        endcase
    end

    assign Y0 = next_state_z[3:1][0]; // next_state[0]
    assign z = next_state_z[0];

endmodule