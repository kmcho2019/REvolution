module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Intermediate variable to hold the result of 'b or c'
wire bc_or;

// Using an intermediate variable for better readability
assign bc_or = b | c;
assign out = (bc_or) ? 1 : a;

// Alternatively, a more direct implementation based on the Karnaugh map
// assign out = (a && ~b && ~c) ? 0 : 1;

// Or, explicitly defining each case based on the Karnaugh map
// assign out = (~b && ~c && a) ? 0 :
//             (~b && ~c && ~a) ? 0 :
//             1;

endmodule