module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // Directly implement the logic without intermediate wires
    assign out = (a & b) | (c & d);
    assign out_n = ~out;

endmodule