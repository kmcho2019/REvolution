module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

assign out = (sel) ? b : a;

// Alternatively, you can use a procedural assignment within an always block:
// always @(a, b, sel) begin
//     if (sel)
//         out <= b;
//     else
//         out <= a;
// end

endmodule