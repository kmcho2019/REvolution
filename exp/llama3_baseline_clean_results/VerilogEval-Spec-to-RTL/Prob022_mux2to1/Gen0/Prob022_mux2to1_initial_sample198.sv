module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

assign out = (sel == 1'b0) ? a : b;

// Alternatively, you can use a simple if-else statement or a logic gate implementation
// assign out = sel ? b : a;  // Using ternary operator in a concise form
// always @(a, b, sel) begin
//     if (sel == 1'b0) out = a;
//     else out = b;
// end

endmodule