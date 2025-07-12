module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Create an 8-bit wide selection mask
    wire [7:0] sel_mask = {8{sel}};
    
    // Bitwise implementation of the mux
    assign out = (a & ~sel_mask) | (b & sel_mask);

endmodule