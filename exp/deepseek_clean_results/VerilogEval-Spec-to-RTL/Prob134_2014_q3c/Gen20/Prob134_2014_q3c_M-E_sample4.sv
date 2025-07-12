module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Treat undefined states (101-111) as 000
    wire [2:0] clean_y = (y > 3'b100) ? 3'b000 : y;

    // Compute all possible next states in parallel
    wire [2:0] next_if_x0 = 
        (clean_y == 3'b000) ? 3'b000 :
        (clean_y == 3'b001) ? 3'b001 :
        (clean_y == 3'b010) ? 3'b010 :
        (clean_y == 3'b011) ? 3'b001 :
                             3'b011;  // clean_y == 3'b100

    wire [2:0] next_if_x1 = 
        (clean_y == 3'b000) ? 3'b001 :
        (clean_y == 3'b001) ? 3'b100 :
        (clean_y == 3'b010) ? 3'b001 :
        (clean_y == 3'b011) ? 3'b010 :
                             3'b100;  // clean_y == 3'b100

    // Select next state based on x
    wire [2:0] Y = x ? next_if_x1 : next_if_x0;

    // Compute output z in parallel
    wire z_if_x0 = 
        (clean_y == 3'b011) || (clean_y == 3'b100);
    
    wire z_if_x1 = 
        (clean_y == 3'b011) || (clean_y == 3'b100);

    assign z = x ? z_if_x1 : z_if_x0;
    
    // Y0 is simply the LSB of next state
    assign Y0 = Y[0];

endmodule