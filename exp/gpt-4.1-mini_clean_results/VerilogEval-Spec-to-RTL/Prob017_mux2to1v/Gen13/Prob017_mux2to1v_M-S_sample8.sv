module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // 2-to-1 mux: select b when sel=1, else a
    assign out = sel ? b : a;
endmodule