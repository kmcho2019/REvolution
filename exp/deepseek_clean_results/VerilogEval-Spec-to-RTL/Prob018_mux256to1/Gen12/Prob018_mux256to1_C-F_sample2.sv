module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Direct bit selection - most efficient implementation
    // Synthesis tools will optimize this appropriately
    assign out = in[sel];

endmodule