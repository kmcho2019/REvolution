module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Direct vector muxing: if sel=0 select a else select b
    assign out = sel ? b : a;
endmodule