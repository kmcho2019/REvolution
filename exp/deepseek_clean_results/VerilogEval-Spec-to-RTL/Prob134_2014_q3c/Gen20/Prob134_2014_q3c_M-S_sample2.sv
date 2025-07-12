module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state calculation
    wire [2:0] next_state_x0 = 
        (y == 3'b000) ? 3'b000 :
        (y == 3'b001) ? 3'b001 :
        (y == 3'b010) ? 3'b010 :
        (y == 3'b011) ? 3'b001 : 3'b011;
    
    wire [2:0] next_state_x1 = 
        (y == 3'b000) ? 3'b001 :
        (y == 3'b001) ? 3'b100 :
        (y == 3'b010) ? 3'b001 :
        (y == 3'b011) ? 3'b010 : 3'b100;

    // Select next state based on x
    wire [2:0] next_state = x ? next_state_x1 : next_state_x0;

    // Output assignments
    assign Y0 = next_state[0];
    assign z = (y == 3'b011) || (y == 3'b100);

endmodule