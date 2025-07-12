module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);
    // Combine inputs into a 4-bit vector to address the LUT
    // Bit order: d c b a (MSB to LSB)
    wire [3:0] addr = {d, c, b, a};

    always @(*) begin
        case(addr)
            4'b0000: out = 1'b1; // cd=00 ab=00: 1
            4'b0001: out = 1'b1; // cd=00 ab=01: 1
            4'b0010: out = 1'b1; // cd=00 ab=10: 1 (note K-map position: ab=10, cd=00)
            4'b0011: out = 1'b0; // cd=00 ab=11: 0
            4'b0100: out = 1'b1; // cd=01 ab=00: 1
            4'b0101: out = 1'b0; // cd=01 ab=01: 0
            4'b0110: out = 1'b1; // cd=01 ab=10: 1
            4'b0111: out = 1'b0; // cd=01 ab=11: 0
            4'b1000: out = 1'b1; // cd=10 ab=00: 1
            4'b1001: out = 1'b1; // cd=10 ab=01: 1
            4'b1010: out = 1'b0; // cd=10 ab=10: 0
            4'b1011: out = 1'b0; // cd=10 ab=11: 0
            4'b1100: out = 1'b0; // cd=11 ab=00: 0
            4'b1101: out = 1'b1; // cd=11 ab=01: 1
            4'b1110: out = 1'b1; // cd=11 ab=10: 1
            4'b1111: out = 1'b1; // cd=11 ab=11: 1
            default: out = 1'b0;
        endcase
    end
endmodule