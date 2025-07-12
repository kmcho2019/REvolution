module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);
// Implement the multiplexer using basic logical operators
assign out = (~sel) ? a : b;
// Alternatively, using if-else within an always block for clarity, though likely less efficient:
// always @(*) begin
//     if (sel) begin
//         out = b;
//     end else begin
//         out = a;
//     end
// end
endmodule