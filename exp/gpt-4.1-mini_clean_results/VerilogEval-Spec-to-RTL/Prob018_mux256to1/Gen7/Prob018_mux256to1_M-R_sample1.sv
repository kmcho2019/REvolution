module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);
    // Directly assign output as the bit of 'in' selected by 'sel'
    assign out = in[sel];
endmodule