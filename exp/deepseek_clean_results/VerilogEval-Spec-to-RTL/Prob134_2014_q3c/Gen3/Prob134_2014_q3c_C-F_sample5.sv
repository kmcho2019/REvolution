module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Combined next state and output logic
    reg [3:0] next_state_and_z; // {Y[2:0], z}
    
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
            default: next_state_and_z = 4'b0000; // Should never occur
        endcase
    end

    assign {Y0, z} = {next_state_and_z[1], next_state_and_z[0]};

endmodule