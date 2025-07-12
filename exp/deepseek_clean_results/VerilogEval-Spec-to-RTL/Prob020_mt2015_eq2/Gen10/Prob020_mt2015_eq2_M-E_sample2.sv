module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // LUT-based equality check
    // Address = {A,B}, output 1 only when A == B (diagonal entries)
    reg [15:0] lut = 16'b0001_0000_0000_0001;
    
    assign z = lut[{A,B}];
endmodule