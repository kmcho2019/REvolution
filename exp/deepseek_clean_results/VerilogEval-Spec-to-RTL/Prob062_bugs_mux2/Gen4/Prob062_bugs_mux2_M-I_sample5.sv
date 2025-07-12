module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Select 'a' when sel=0, 'b' when sel=1
    assign out = sel ? b : a;

endmodule