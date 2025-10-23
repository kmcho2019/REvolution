module Mux4to1 (
    input  wire [3:0] in,
    input  wire [1:0] sel,
    output wire       out
);
    // Combinational 4-to-1 mux using direct indexing (simple and efficient)
    assign out = in[sel];
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Direct combinational indexing of 256-bit input by 8-bit selector
    // This synthesizes to an optimized wide mux without intermediate levels
    assign out = in[sel];
endmodule