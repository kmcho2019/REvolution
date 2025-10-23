module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire [2:0] valid;

    // Assign each valid bit by checking if input is 1
    assign valid[0] = (a == 1'b1) ? 1'b1 : 1'b0;
    assign valid[1] = (b == 1'b1) ? 1'b1 : 1'b0;
    assign valid[2] = (c == 1'b1) ? 1'b1 : 1'b0;

    // Combine all valids with a reduction OR operator
    assign out = |valid;
endmodule