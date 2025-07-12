module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

// Combine inputs into 4-bit vector with order cdab for easier indexing
wire [3:0] idx = {c, d, a, b};

always @(*) begin
    // Decode output using direct truth table mapping as per the Karnaugh map:
    // Index: cdab (c:MSB, b:LSB)
    // The mapping from the Karnaugh map table:
    // cd\ab 00  01  11  10
    // 00 | 1 | 1 | 0 | 1 |
    // 01 | 1 | 0 | 0 | 1 |
    // 11 | 0 | 1 | 1 | 1 |
    // 10 | 1 | 1 | 0 | 0 |
    case (idx)
        4'b0000: out = 1'b1; // cd=00, ab=00
        4'b0001: out = 1'b1; // cd=00, ab=01
        4'b0010: out = 1'b1; // cd=00, ab=10 (note swapped bits)
        4'b0011: out = 1'b0; // cd=00, ab=11
        4'b0100: out = 1'b1; // cd=01, ab=00
        4'b0101: out = 1'b0; // cd=01, ab=01
        4'b0110: out = 1'b1; // cd=01, ab=10 (see note)
        4'b0111: out = 1'b0; // cd=01, ab=11
        4'b1000: out = 1'b1; // cd=10, ab=00
        4'b1001: out = 1'b1; // cd=10, ab=01
        4'b1010: out = 1'b0; // cd=10, ab=10
        4'b1011: out = 1'b0; // cd=10, ab=11
        4'b1100: out = 0'b0; // cd=11, ab=00
        4'b1101: out = 1'b1; // cd=11, ab=01
        4'b1110: out = 1'b1; // cd=11, ab=10
        4'b1111: out = 1'b1; // cd=11, ab=11
        default: out = 1'b0;
    endcase
end

endmodule