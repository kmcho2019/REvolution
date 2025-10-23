module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state computation (parallel evaluation)
    wire [2:0] next_state_x0;
    wire [2:0] next_state_x1;
    
    // x=0 cases
    assign next_state_x0 = (y == 3'b000) ? 3'b000 :
                          (y == 3'b001) ? 3'b001 :
                          (y == 3'b010) ? 3'b010 :
                          (y == 3'b011) ? 3'b001 :
                          (y == 3'b100) ? 3'b011 : 3'b000;
    
    // x=1 cases
    assign next_state_x1 = (y == 3'b000) ? 3'b001 :
                          (y == 3'b001) ? 3'b100 :
                          (y == 3'b010) ? 3'b001 :
                          (y == 3'b011) ? 3'b010 :
                          (y == 3'b100) ? 3'b100 : 3'b000;
    
    // Output computation (combinational)
    wire z_x0, z_x1;
    assign z_x0 = (y == 3'b011) || (y == 3'b100);
    assign z_x1 = (y == 3'b011) || (y == 3'b100);
    
    // Select based on x input
    wire [2:0] Y = x ? next_state_x1 : next_state_x0;
    assign z = x ? z_x1 : z_x0;
    
    // Output assignments
    assign Y0 = Y[0];

endmodule