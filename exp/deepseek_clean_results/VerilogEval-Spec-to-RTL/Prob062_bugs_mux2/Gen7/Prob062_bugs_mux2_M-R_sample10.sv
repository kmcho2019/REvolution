module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    wire [7:0] sel_w = {8{sel}};  // Replicate selector to 8 bits
    
    assign out = (~sel_w & a) | (sel_w & b);

endmodule