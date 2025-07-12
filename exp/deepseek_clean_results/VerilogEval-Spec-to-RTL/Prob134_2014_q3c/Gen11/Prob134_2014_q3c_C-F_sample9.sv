module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    reg [3:0] next_state_and_z; // {next_state[2:0], z}

    always @(*) begin
        case ({y, x})
            {3'b000, 1'b0}: next_state_and_z = {3'b000, 1'b0};
            {3'b000, 1'b1}: next_state_and_z = {3'b001, 1'b0};
            {3'b001, 1'b0}: next_state_and_z = {3'b001, 1'b0};
            {3'b001, 1'b1}: next_state_and_z = {3'b100, 1'b0};
            {3'b010, 1'b0}: next_state_and_z = {3'b010, 1'b0};
            {3'b010, 1'b1}: next_state_and_z = {3'b001, 1'b0};
            {3'b011, 1'b0}: next_state_and_z = {3'b001, 1'b1};
            {3'b011, 1'b1}: next_state_and_z = {3'b010, 1'b1};
            {3'b100, 1'b0}: next_state_and_z = {3'b011, 1'b1};
            {3'b100, 1'b1}: next_state_and_z = {3'b100, 1'b1};
            default: next_state_and_z = {3'b000, 1'b0}; // Safe default
        endcase
    end

    assign Y0 = next_state_and_z[3:1][0]; // next_state[0]
    assign z = next_state_and_z[0];

endmodule