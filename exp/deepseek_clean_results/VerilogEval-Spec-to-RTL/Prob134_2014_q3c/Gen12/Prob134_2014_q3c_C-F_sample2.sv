module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Optimized Y0 computation - direct from truth table
    assign Y0 = x ? 
               ((y == 3'b000) | (y == 3'b010) | (y == 3'b100)) :  // x=1 cases where Y0=1
               ((y == 3'b001) | (y == 3'b011) | (y == 3'b100));    // x=0 cases where Y0=1

    // Most efficient z implementation - pattern matching
    assign z = (y[2] & ~y[1]) | (y[1] & y[0]);  // y==3'b011 (011) or y==3'b100 (100)

endmodule