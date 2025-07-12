module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

always @(*) begin
    // Map inputs to 4-bit index according to K-map ordering: cd (row), ab (column)
    // Index bit order: c d a b, MSB to LSB
    case ({c, d, a, b})
        4'b0000: out = 1; // m0
        4'b0001: out = 1; // m1
        4'b0010: out = 1; // m2
        4'b0011: out = 0; // m3
        4'b0100: out = 1; // m4
        4'b0101: out = 0; // m5
        4'b0110: out = 1; // m6
        4'b0111: out = 0; // m7
        4'b1000: out = 1; // m8
        4'b1001: out = 1; // m9
        4'b1010: out = 0; // m10
        4'b1011: out = 0; // m11
        4'b1100: out = 0; // m12
        4'b1101: out = 1; // m13
        4'b1110: out = 1; // m14
        4'b1111: out = 1; // m15
        default: out = 0;
    endcase
end

endmodule