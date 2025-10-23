module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

// Combine inputs to form row and column indices for K-map
wire [1:0] row = {c, d}; // cd
wire [1:0] col = {a, b}; // ab

always @(*) begin
    // Implement the K-map as a truth table using concatenated inputs
    case ({row, col})
        6'b0000_00: out = 1'b1; // cd=00 ab=00
        6'b0000_01: out = 1'b1; // cd=00 ab=01
        6'b0000_11: out = 1'b0; // cd=00 ab=11
        6'b0000_10: out = 1'b1; // cd=00 ab=10

        6'b0001_00: out = 1'b1; // cd=01 ab=00
        6'b0001_01: out = 1'b0; // cd=01 ab=01
        6'b0001_11: out = 1'b0; // cd=01 ab=11
        6'b0001_10: out = 1'b1; // cd=01 ab=10

        6'b0011_00: out = 1'b0; // cd=11 ab=00
        6'b0011_01: out = 1'b1; // cd=11 ab=01
        6'b0011_11: out = 1'b1; // cd=11 ab=11
        6'b0011_10: out = 1'b1; // cd=11 ab=10

        6'b0010_00: out = 1'b1; // cd=10 ab=00
        6'b0010_01: out = 1'b1; // cd=10 ab=01
        6'b0010_11: out = 1'b0; // cd=10 ab=11
        6'b0010_10: out = 1'b0; // cd=10 ab=10

        default: out = 1'b0; // safety default
    endcase
end

endmodule