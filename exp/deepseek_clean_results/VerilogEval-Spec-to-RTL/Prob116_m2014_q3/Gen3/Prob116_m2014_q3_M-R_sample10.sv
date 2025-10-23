module TopModule(
    input [3:0] x,  // x[3], x[2], x[1], x[0] - but we'll use x[3:1] as per K-map
    output f
);
    // Note: x[3] is MSB, x[0] is LSB in Verilog convention
    // Karnaugh map uses x[3]x[4] as rows, but our input is x[3:0]
    // Assuming x[3] is row MSB, x[2] is row LSB, x[1]x[0] are column bits
    
    assign f = x[3] |                         // Covers rows 3 and 4
               (x[2] & x[1] & x[0]) |        // Row 2, column 11
               (~x[3] & ~x[2] & ~x[1] & x[0]); // Row 1, column 01
endmodule