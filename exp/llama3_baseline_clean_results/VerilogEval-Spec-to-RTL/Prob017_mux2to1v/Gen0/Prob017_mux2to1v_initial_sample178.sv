module TopModule(a, b, sel, out);
    input [99:0] a;
    input [99:0] b;
    input sel;
    output [99:0] out;

    assign out = sel ? b : a;

endmodule