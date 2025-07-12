module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Next state bits derived from present state y and input x
    // States: 000,001,010,011,100
    // From the table:
    // next_state[2] = y[2] & (~y[1] | ~x)
    // next_state[1] = (~y[2] & y[0]) | (~y[2] & ~y[1] & x)
    // next_state[0] = (y == 000 & x) | (y == 001 & ~x) | (y == 010 & x) | (y == 011 & ~x)

    wire ns2, ns1, ns0;

    assign ns2 = (y[2] & (~y[1] | ~x));
    assign ns1 = (~y[2] & y[0]) | (~y[2] & ~y[1] & x);

    assign ns0 = ((y == 3'b000) & x) |
                 ((y == 3'b001) & (~x)) |
                 ((y == 3'b010) & x) |
                 ((y == 3'b011) & (~x));

    wire [2:0] Y = {ns2, ns1, ns0};

    // Output Y0 is LSB of next state
    assign Y0 = ns0;

    // Output z = 1 when y=011 or y=100
    assign z = (~y[2] & y[1] & y[0]) | (y[2] & ~y[1] & ~y[0]);

endmodule