module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Create replicated sel signal for bitwise operations
    wire [7:0] sel_vec = {8{sel}};
    
    // Bitwise majority vote between a, b, and sel_vec
    assign out = (a & b) | (a & sel_vec) | (b & sel_vec);

endmodule