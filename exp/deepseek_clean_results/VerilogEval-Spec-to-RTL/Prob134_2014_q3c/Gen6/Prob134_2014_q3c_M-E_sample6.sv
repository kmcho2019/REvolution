module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Parallel next state computation for each current state
    wire [2:0] next_state_000 = x ? 3'b001 : 3'b000;
    wire [2:0] next_state_001 = x ? 3'b100 : 3'b001;
    wire [2:0] next_state_010 = x ? 3'b001 : 3'b010;
    wire [2:0] next_state_011 = x ? 3'b010 : 3'b001;
    wire [2:0] next_state_100 = x ? 3'b100 : 3'b011;

    // Select next state based on current state
    wire [2:0] Y = (y == 3'b000) ? next_state_000 :
                   (y == 3'b001) ? next_state_001 :
                   (y == 3'b010) ? next_state_010 :
                   (y == 3'b011) ? next_state_011 :
                   (y == 3'b100) ? next_state_100 :
                   3'b000;  // default case

    // Output logic (combinational)
    wire z = (y == 3'b011) ? 1'b1 :
             (y == 3'b100) ? 1'b1 :
             1'b0;

    assign Y0 = Y[0];

endmodule