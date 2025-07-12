module TopModule(
    input  [3:0] x,
    output       f
);

    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    wire not_x3 = ~x3;
    wire not_x2 = ~x2;
    wire not_x1 = ~x1;
    wire not_x0 = ~x0;

    wire first_term = not_x3 & not_x2 & not_x1;
    wire second_term = x3 & (x2 | not_x1 | not_x0);

    assign f = first_term | second_term;

endmodule