module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state and output logic
    reg [3:0] next_state_z;  // {Y[2:0], z}

    always @(*) begin
        case ({y, x})
            // x=0 cases
            {3'b000, 1'b0}: next_state_z = {3'b000, 1'b0};
            {3'b001, 1'b0}: next_state_z = {3'b001, 1'b0};
            {3'b010, 1'b0}: next_state_z = {3'b010, 1'b0};
            {3'b011, 1'b0}: next_state_z = {3'b001, 1'b1};
            {3'b100, 1'b0}: next_state_z = {3'b011, 1'b1};
            // x=1 cases
            {3'b000, 1'b1}: next_state_z = {3'b001, 1'b0};
            {3'b001, 1'b1}: next_state_z = {3'b100, 1'b0};
            {3'b010, 1'b1}: next_state_z = {3'b001, 1'b0};
            {3'b011, 1'b1}: next_state_z = {3'b010, 1'b1};
            {3'b100, 1'b1}: next_state_z = {3'b100, 1'b1};
            // Default case (should never occur)
            default:        next_state_z = {3'b000, 1'b0};
        endcase
    end

    // Output assignments
    assign Y0 = next_state_z[3];  // Y[0] is bit 3 of next_state_z (since we packed Y[2:0] in bits [3:1])
    assign z = next_state_z[0];

endmodule