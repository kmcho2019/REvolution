module TopModule (
    output one
);
    // Optimal implementation: direct constant assignment
    assign one = 1'b1;
    
    // Alternative educational implementations:
    // 1. Using OR gate: or g1(one, 1'b1, 1'b1);
    // 2. Using NOR + NOT: nor g2(w, 1'b0, 1'b0); not g3(one, w);
    // 3. Using reduction OR: assign one = |(1'b1);
endmodule