module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Parallel computation of next state transitions
    wire [2:0] next_state_x0, next_state_x1;
    
    // Compute next states for x=0 case
    assign next_state_x0 = (y == 3'b000) ? 3'b000 :
                          (y == 3'b001) ? 3'b001 :
                          (y == 3'b010) ? 3'b010 :
                          (y == 3'b011) ? 3'b001 :
                          (y == 3'b100) ? 3'b011 : 3'b000;
    
    // Compute next states for x=1 case
    assign next_state_x1 = (y == 3'b000) ? 3'b001 :
                          (y == 3'b001) ? 3'b100 :
                          (y == 3'b010) ? 3'b001 :
                          (y == 3'b011) ? 3'b010 :
                          (y == 3'b100) ? 3'b100 : 3'b000;
    
    // Select next state based on x input
    wire [2:0] Y = x ? next_state_x1 : next_state_x0;
    
    // Compute output z
    assign z = (y == 3'b011) ? 1'b1 :
               (y == 3'b100) ? 1'b1 : 1'b0;
    
    // Y0 is LSB of next state
    assign Y0 = Y[0];

endmodule