module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    // 2:1 mux with case statement in continuous assignment
    // Combines minimalism with explicit selection logic
    assign out = (sel) ? b : a;
endmodule