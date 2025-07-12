module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bitwise OR via LUT-style implementation
    assign out_or_bitwise[0] = a[0] | b[0];
    assign out_or_bitwise[1] = a[1] | b[1];
    assign out_or_bitwise[2] = a[2] | b[2];
    
    // Logical OR via reduction
    wire a_or = |a;
    wire b_or = |b;
    assign out_or_logical = a_or | b_or;
    
    // NOT operations with explicit bit ordering
    assign out_not[5:3] = ~b;  // Upper bits: inverse of b
    assign out_not[2:0] = ~a;  // Lower bits: inverse of a
endmodule