module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Calculate bit offset by multiplying sel by 4 and slice 4 bits directly
    assign out = in[sel * 4 +: 4];
endmodule