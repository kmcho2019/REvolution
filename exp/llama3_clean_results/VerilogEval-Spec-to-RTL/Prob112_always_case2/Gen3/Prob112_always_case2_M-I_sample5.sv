module TopModule(
    input [3:0] in,
    output [1:0] pos
);

    wire p3, p2, p1, p0;

    // Priority encoder logic
    assign p3 = in[3];
    assign p2 = ~in[3] & in[2];
    assign p1 = ~in[3] & ~in[2] & in[1];
    assign p0 = ~in[3] & ~in[2] & ~in[1] & in[0];

    // Output logic to encode the position of the first '1'
    assign pos[1] = (p3 | p2); // First '1' in MSB or second MSB position
    assign pos[0] = (p3 | p1); // First '1' in MSB or second LSB position

endmodule