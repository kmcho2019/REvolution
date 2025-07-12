module TopModule(
    input [3:0] x,
    output f
);
    // x[3] = x[3], x[4] = x[2], x[1] = x[1], x[0] = x[0] per standard numbering
    // Note: Original problem statement uses x[1]x[2] for columns, x[3]x[4] for rows
    // Assuming x[3:0] = {x[3],x[2],x[1],x[0]}
    assign f = (x[3] & x[2]) |               // x[3]x[4]=11 cases
               (x[3] & ~x[2] & ~x[0]) |     // x[3]x[4]=10 with x[1]x[2]=00 or 01
               (~x[3] & x[2] & x[1] & x[0]); // x[3]x[4]=01 with x[1]x[2]=11
endmodule