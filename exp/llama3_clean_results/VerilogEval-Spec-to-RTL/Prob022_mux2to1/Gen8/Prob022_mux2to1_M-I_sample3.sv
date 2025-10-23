module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);
// Using a logic gate-level implementation
assign out = (sel == 1'b0)? a : b;

// Alternatively, we can use a gate-level implementation
// assign out = (~sel) & a | sel & b;
endmodule