module TopModule(
    input [3:0] x,  // x[3]x[4]x[1]x[2] mapping
    output f
);

    // Correct bit mapping: {x[3],x[4]} for rows, {x[1],x[2]} for columns
    // Implement minimal SOP form from K-map
    assign f = (~x[3] & x[4] & x[1] & x[2]) |  // 01-11 cell
               (x[3] & ~x[4] & ~x[2]) |       // 10-00 and 10-01 cells
               (x[3] & x[4] & ~x[1]);         // 11-00 and 11-01 cells

endmodule