module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    assign Y1 = A & w;
    assign Y3 = (B | C | E | F) & ~w;

endmodule