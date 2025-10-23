module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output wire   z
);

    assign z = (A == B);

endmodule