module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    reg [3:0] next_state_and_z; // {next_state[2:0], z}

    // Combined next state and output logic
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
        endcase
    end

    assign Y0 = next_state_and_z[3]; // Y[0] is bit 3 of the 4-bit reg
    assign z = next_state_and_z[0];

endmodule