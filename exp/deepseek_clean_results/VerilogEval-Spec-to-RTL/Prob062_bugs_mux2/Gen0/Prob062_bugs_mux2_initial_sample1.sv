module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    wire [7:0] selected;

    assign selected = sel ? b : a;
    assign out = selected[0]; // Assuming we want the LSB of the selected input

endmodule