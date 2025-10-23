module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // State transition LUT (parallel evaluation)
    wire [2:0] next_state_x0 = 
        ({3{y == 3'b000}} & 3'b000) |
        ({3{y == 3'b001}} & 3'b001) |
        ({3{y == 3'b010}} & 3'b010) |
        ({3{y == 3'b011}} & 3'b001) |
        ({3{y == 3'b100}} & 3'b011);

    wire [2:0] next_state_x1 = 
        ({3{y == 3'b000}} & 3'b001) |
        ({3{y == 3'b001}} & 3'b100) |
        ({3{y == 3'b010}} & 3'b001) |
        ({3{y == 3'b011}} & 3'b010) |
        ({3{y == 3'b100}} & 3'b100);

    // Select next state based on x
    wire [2:0] next_state = x ? next_state_x1 : next_state_x0;

    // Output Y0 is next_state[0]
    assign Y0 = next_state[0];

    // Output z is 1 for states 011 (3) and 100 (4)
    assign z = (y == 3'b011) | (y == 3'b100);

endmodule