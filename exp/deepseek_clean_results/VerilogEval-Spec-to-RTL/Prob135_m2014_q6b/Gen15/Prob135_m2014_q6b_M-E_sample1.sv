module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        // Cases where y[1] becomes 1
        (~w & (y == 3'b001)) |  // B->C when w=0
        (w & (y == 3'b001 | y == 3'b010 | y == 3'b100 | y == 3'b101)) |  // ->D when w=1
        (~w & (y == 3'b101));    // F->C when w=0

    /* Alternative implementation using bit-level logic
    assign next_y1 = 
        (~w & ~y[2] & ~y[1] & y[0]) |  // B->C (001->010)
        (w & (~y[2] & (~y[1] | ~y[0]))) |  // B/C->D
        (w & (y[2] & ~y[1])) |  // E/F->D
        (~w & y[2] & ~y[1] & y[0]);  // F->C
    */

endmodule