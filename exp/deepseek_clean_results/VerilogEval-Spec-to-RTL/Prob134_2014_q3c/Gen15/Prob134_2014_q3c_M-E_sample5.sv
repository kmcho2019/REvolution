module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Parallel next state computation
    wire [2:0] next_state_0;
    wire [2:0] next_state_1;
    
    // Next state when x=0
    assign next_state_0 = (y == 3'b000) ? 3'b000 :
                         (y == 3'b001) ? 3'b001 :
                         (y == 3'b010) ? 3'b010 :
                         (y == 3'b011) ? 3'b001 :
                         (y == 3'b100) ? 3'b011 : 3'b000;
    
    // Next state when x=1
    assign next_state_1 = (y == 3'b000) ? 3'b001 :
                         (y == 3'b001) ? 3'b100 :
                         (y == 3'b010) ? 3'b001 :
                         (y == 3'b011) ? 3'b010 :
                         (y == 3'b100) ? 3'b100 : 3'b000;
    
    // Mux to select next state based on x
    wire [2:0] Y = x ? next_state_1 : next_state_0;
    
    // Output logic
    assign z = (y == 3'b011) || (y == 3'b100);
    
    // Y0 is directly from next state
    assign Y0 = Y[0];

endmodule