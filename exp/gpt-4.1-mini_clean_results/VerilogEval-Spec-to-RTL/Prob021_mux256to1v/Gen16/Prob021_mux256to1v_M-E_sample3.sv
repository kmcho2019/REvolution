module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Each selection selects 4 bits from 'in' starting at sel*4
    // Use Verilog indexed part-select operator [start +: width]
    assign out = in[sel * 4 +: 4];
endmodule