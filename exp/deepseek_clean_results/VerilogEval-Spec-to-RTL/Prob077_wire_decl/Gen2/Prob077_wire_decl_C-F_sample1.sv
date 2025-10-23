module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // First layer: AND operations
    wire ab_and = a & b;
    wire cd_and = c & d;

    // Second layer: Output operations
    assign {out, out_n} = {ab_and | cd_and, ~(ab_and | cd_and)};

endmodule