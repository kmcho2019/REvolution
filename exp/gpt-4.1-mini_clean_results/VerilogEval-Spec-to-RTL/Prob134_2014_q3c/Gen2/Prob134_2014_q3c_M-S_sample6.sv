module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    wire [2:0] next_state;
    wire       z_wire;

    // Combined next state and output z logic
    // Using a function of y and x to select next_state and z simultaneously
    assign {z_wire, next_state} = (y == 3'b000) ? {1'b0, (x ? 3'b001 : 3'b000)} :
                                 (y == 3'b001) ? {1'b0, (x ? 3'b100 : 3'b001)} :
                                 (y == 3'b010) ? {1'b0, (x ? 3'b001 : 3'b010)} :
                                 (y == 3'b011) ? {1'b1, (x ? 3'b010 : 3'b001)} :
                                 (y == 3'b100) ? {1'b1, (x ? 3'b100 : 3'b011)} :
                                 {1'b0, 3'b000};

    assign Y0 = next_state[0];
    assign z  = z_wire;

endmodule