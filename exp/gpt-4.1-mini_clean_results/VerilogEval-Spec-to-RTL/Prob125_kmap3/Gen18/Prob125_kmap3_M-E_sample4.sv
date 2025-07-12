module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't care
    output reg out
);

    // Encode inputs into a 4-bit vector to use as case selector:
    // Inputs ordered as: c d b a for convenience
    wire [3:0] idx = {c, d, b, a};

    always @(*) begin
        case (idx)
            4'b0000: out = 1'b0; // c=0 d=0 b=0 a=0 (cd=00, ab=00) -> 0
            4'b0001: out = 1'b1; // cd=00 ab=01 -> 1
            4'b0010: out = 1'b1; // cd=00 ab=10 -> 1
            4'b0011: out = 1'bx; // cd=00 ab=11 -> d (don't care), assign x
            4'b0100: out = 1'b0; // cd=01 ab=00 -> 0
            4'b0101: out = 1'b0; // cd=01 ab=01 -> 0
            4'b0110: out = 1'b0; // cd=01 ab=10 -> d (don't care), assign 0 for convenience
            4'b0111: out = 1'b0; // cd=01 ab=11 -> d (don't care), assign 0 for convenience
            4'b1000: out = 1'b0; // cd=10 ab=00 -> 0
            4'b1001: out = 1'b1; // cd=10 ab=01 -> 1
            4'b1010: out = 1'b1; // cd=10 ab=10 -> 1
            4'b1011: out = 1'b1; // cd=10 ab=11 -> 1
            4'b1100: out = 1'b0; // cd=11 ab=00 -> 0
            4'b1101: out = 1'b1; // cd=11 ab=01 -> 1
            4'b1110: out = 1'b1; // cd=11 ab=10 -> 1
            4'b1111: out = 1'b1; // cd=11 ab=11 -> 1
            default: out = 1'b0; // default safe assignment
        endcase
    end

endmodule