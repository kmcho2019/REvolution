module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Directly assign the output based on the select signal
    assign out = (sel == 1'b1) ? b : a;

endmodule