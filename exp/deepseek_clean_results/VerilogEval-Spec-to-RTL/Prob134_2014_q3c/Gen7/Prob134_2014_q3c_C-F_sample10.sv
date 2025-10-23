module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state logic
    reg [2:0] next_state;
    always @(*) begin
        case ({y, x})
            {3'b000, 1'b0}: next_state = 3'b000;
            {3'b000, 1'b1}: next_state = 3'b001;
            {3'b001, 1'b0}: next_state = 3'b001;
            {3'b001, 1'b1}: next_state = 3'b100;
            {3'b010, 1'b0}: next_state = 3'b010;
            {3'b010, 1'b1}: next_state = 3'b001;
            {3'b011, 1'b0}: next_state = 3'b001;
            {3'b011, 1'b1}: next_state = 3'b010;
            {3'b100, 1'b0}: next_state = 3'b011;
            {3'b100, 1'b1}: next_state = 3'b100;
            default: next_state = 3'b000; // Should never occur
        endcase
    end

    // Output assignments
    assign Y0 = next_state[0];
    assign z = (y == 3'b011) | (y == 3'b100); // More efficient than separate comparisons

endmodule