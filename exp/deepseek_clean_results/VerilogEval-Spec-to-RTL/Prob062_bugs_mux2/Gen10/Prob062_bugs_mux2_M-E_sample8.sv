module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    // XOR reduction of selected input (produces parity bit)
    assign out = sel ? ^b : ^a;

endmodule