module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Output z is 1 only in states 011 and 100
    assign z = (y == 3'b011) | (y == 3'b100);

    // Compute Y0 (next_state[0]) directly:
    // Y0 is:
    // - 0 when (x=0 and state=000) or (x=0 and state=010)
    // - 1 otherwise (from state transition table)
    assign Y0 = ~((~x & (y == 3'b000)) | (~x & (y == 3'b010)));

endmodule