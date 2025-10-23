module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

assign out = (sel == 1'b0) ? a : b;

// Alternatively, the same functionality can be achieved using an if-else statement within an always block:
// always @(*) begin
//     if (sel == 1'b0) begin
//         out = a;
//     end else begin
//         out = b;
//     end
// end

endmodule