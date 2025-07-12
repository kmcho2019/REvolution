module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // State bitmasks for parallel evaluation
    wire is_state_000 = (y == 3'b000);
    wire is_state_001 = (y == 3'b001);
    wire is_state_010 = (y == 3'b010);
    wire is_state_011 = (y == 3'b011);
    wire is_state_100 = (y == 3'b100);

    // Parallel next state computation
    wire [2:0] next_state_000 = x ? 3'b001 : 3'b000;
    wire [2:0] next_state_001 = x ? 3'b100 : 3'b001;
    wire [2:0] next_state_010 = x ? 3'b001 : 3'b010;
    wire [2:0] next_state_011 = x ? 3'b010 : 3'b001;
    wire [2:0] next_state_100 = x ? 3'b100 : 3'b011;

    // Priority-encoded next state selection
    wire [2:0] Y = 
        is_state_100 ? next_state_100 :
        is_state_011 ? next_state_011 :
        is_state_010 ? next_state_010 :
        is_state_001 ? next_state_001 :
        is_state_000 ? next_state_000 :
        3'b000;  // Default case

    // Output logic
    wire z = 
        is_state_100 ? 1'b1 :
        is_state_011 ? 1'b1 :
        1'b0;  // All other states output 0

    assign Y0 = Y[0];

endmodule