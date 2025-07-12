module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    wire [7:0] sel_wire = {8{sel}};  // Replicate selector to 8 bits
    assign out = (~sel_wire & a) | (sel_wire & b);

endmodule