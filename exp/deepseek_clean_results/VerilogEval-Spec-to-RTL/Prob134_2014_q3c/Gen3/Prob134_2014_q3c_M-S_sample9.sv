module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Combined next state and output logic
    wire [2:0] next_state;
    assign {next_state, z} = 
        (y == 3'b000) ? {x ? 3'b001 : 3'b000, 1'b0} :
        (y == 3'b001) ? {x ? 3'b100 : 3'b001, 1'b0} :
        (y == 3'b010) ? {x ? 3'b001 : 3'b010, 1'b0} :
        (y == 3'b011) ? {x ? 3'b010 : 3'b001, 1'b1} :
        /* y == 3'b100 */ {x ? 3'b100 : 3'b011, 1'b1};

    assign Y0 = next_state[0];

endmodule