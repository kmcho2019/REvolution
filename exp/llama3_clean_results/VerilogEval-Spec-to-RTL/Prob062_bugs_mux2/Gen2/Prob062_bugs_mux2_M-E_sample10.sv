module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    wire sel_bar;
    assign sel_bar = ~sel;

    assign out = ({8{sel_bar}} & a) | ({8{sel}} & b);

endmodule