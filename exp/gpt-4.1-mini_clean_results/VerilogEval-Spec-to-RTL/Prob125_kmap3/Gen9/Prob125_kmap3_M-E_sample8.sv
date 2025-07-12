module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care, handled in truth table
    output reg out
);

    // Combine inputs into a 4-bit vector for indexing:
    // bit3 = c, bit2 = d, bit1 = a, bit0 = b
    wire [3:0] idx = {c, d, a, b};

    always @(*) begin
        case (idx)
            // cd=00 (c=0,d=0)
            4'b0000: out = 1'b0; // ab=00
            4'b0001: out = 1'b1; // ab=01
            4'b0010: out = 1'b1; // ab=10
            4'b0011: out = 1'bx; // ab=11 (d=don't care) assign x or 0/1, choose 0
            // cd=01 (c=0,d=1)
            4'b0100: out = 1'b0; // ab=00
            4'b0101: out = 1'b0; // ab=01
            4'b0110: out = 1'b0; // ab=10 (d=don't care, assigned 0)
            4'b0111: out = 1'b0; // ab=11 (d=don't care, assigned 0)
            // cd=10 (c=1,d=0)
            4'b1000: out = 1'b0; // ab=00
            4'b1001: out = 1'b1; // ab=01
            4'b1010: out = 1'b1; // ab=10
            4'b1011: out = 1'b1; // ab=11
            // cd=11 (c=1,d=1)
            4'b1100: out = 1'b0; // ab=00
            4'b1101: out = 1'b1; // ab=01
            4'b1110: out = 1'b1; // ab=10
            4'b1111: out = 1'b1; // ab=11
            default: out = 1'b0; // default safe output
        endcase
    end

endmodule