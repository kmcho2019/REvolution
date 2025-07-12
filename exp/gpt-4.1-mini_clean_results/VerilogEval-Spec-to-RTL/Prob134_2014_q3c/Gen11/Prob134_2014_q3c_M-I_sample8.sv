module TopModule (
    input        clk,    // clock input (unused)
    input        x,
    input  [2:0] y,      // present state
    output       Y0,
    output       z
);

    localparam [2:0]
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100;

    wire [2:0] next_state;
    wire       next_z;

    // Next state logic
    assign next_state = (y == S0) ? (x ? S1 : S0) :
                        (y == S1) ? (x ? S4 : S1) :
                        (y == S2) ? (x ? S1 : S2) :
                        (y == S3) ? (x ? S2 : S1) :
                        (y == S4) ? (x ? S4 : S3) :
                        S0;

    // Output z depends on present state y
    assign next_z = (y == S3) || (y == S4);

    // Y0 is LSB of next state
    assign Y0 = next_state[0];
    assign z  = next_z;

endmodule