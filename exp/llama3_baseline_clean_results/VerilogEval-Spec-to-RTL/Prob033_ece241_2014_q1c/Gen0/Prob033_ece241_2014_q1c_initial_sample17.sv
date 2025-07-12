module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    assign {overflow, s} = {1'b0, a} + {1'b0, b};

    // Alternatively, to explicitly check for overflow
    // assign s = a + b;
    // assign overflow = (a[7] == b[7]) && (a[7] != s[7]);

endmodule