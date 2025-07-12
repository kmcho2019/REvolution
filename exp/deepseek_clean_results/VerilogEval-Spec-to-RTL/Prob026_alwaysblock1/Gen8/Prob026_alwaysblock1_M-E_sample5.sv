module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Direct bitwise AND implementation
    assign out_assign = a & b;

    // LUT-style implementation using a small array
    reg [0:3] lut;
    initial begin
        lut[0] = 1'b0;  // 00
        lut[1] = 1'b0;  // 01
        lut[2] = 1'b0;  // 10
        lut[3] = 1'b1;  // 11
    end

    always @(*) begin
        out_alwaysblock = lut[{a, b}];
    end

endmodule