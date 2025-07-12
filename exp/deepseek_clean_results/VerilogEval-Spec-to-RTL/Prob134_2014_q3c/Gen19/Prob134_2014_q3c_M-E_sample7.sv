module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state computation (Y[2:0])
    wire [2:0] Y;
    
    // State 000
    wire [2:0] next_000 = x ? 3'b001 : 3'b000;
    // State 001
    wire [2:0] next_001 = x ? 3'b100 : 3'b001;
    // State 010
    wire [2:0] next_010 = x ? 3'b001 : 3'b010;
    // State 011
    wire [2:0] next_011 = x ? 3'b010 : 3'b001;
    // State 100
    wire [2:0] next_100 = x ? 3'b100 : 3'b011;
    
    // Hierarchical mux tree for next state
    wire [2:0] next_state_low = (y[1:0] == 2'b00) ? next_000 :
                               (y[1:0] == 2'b01) ? next_001 :
                               (y[1:0] == 2'b10) ? next_010 : next_011;
    
    assign Y = y[2] ? next_100 : next_state_low;
    
    // Output z computation (parallel with next state)
    wire z_000 = 1'b0;
    wire z_001 = 1'b0;
    wire z_010 = 1'b0;
    wire z_011 = x ? 1'b1 : 1'b1;  // Same for both x cases
    wire z_100 = 1'b1;
    
    wire z_low = (y[1:0] == 2'b00) ? z_000 :
                (y[1:0] == 2'b01) ? z_001 :
                (y[1:0] == 2'b10) ? z_010 : z_011;
    
    assign z = y[2] ? z_100 : z_low;
    
    // Y0 is simply the LSB of next state
    assign Y0 = Y[0];

endmodule