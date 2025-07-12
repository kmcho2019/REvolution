module TopModule (
    input  a,    // Input A
    input  b,    // Input B
    input  sel,  // Select signal (0=A, 1=B)
    output out   // Output
);
    // 2:1 Mux implementation using ternary operator
    // Selects 'a' when sel=0, 'b' when sel=1
    assign out = sel ? b : a;
endmodule