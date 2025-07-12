module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire [3:0] addr = {a,b,c,d};

// 16-bit LUT encoding output for all input combinations indexed by {a,b,c,d}
localparam [15:0] LUT = 16'b1000101111010111;

// Assign output as the bit selected by the input combination index
assign out = LUT[addr];

endmodule