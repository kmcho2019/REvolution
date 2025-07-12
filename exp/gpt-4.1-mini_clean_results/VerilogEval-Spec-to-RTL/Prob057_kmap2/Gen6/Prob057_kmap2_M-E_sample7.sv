module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// For cd=00 (c=0,d=0): outputs = 1 1 0 1 for ab=00,01,11,10
// Simplify: For ab 00->1, 01->1, 10->1, 11->0
// So output = ~(a & b) (NAND)

wire out_00 = ~(a & b);

// For cd=01 (c=0,d=1): outputs = 1 0 0 1 for ab=00,01,11,10
// So for ab:
// 00 ->1
// 01 ->0
// 10 ->1
// 11 ->0
// This corresponds to output = ~b

wire out_01 = ~b;

// For cd=11 (c=1,d=1): outputs = 0 1 1 1 for ab=00,01,11,10
// ab:
// 00->0
// 01->1
// 11->1
// 10->1
// output = b | a

wire out_11 = a | b;

// For cd=10 (c=1,d=0): outputs = 1 1 0 0 for ab=00,01,11,10
// ab:
// 00->1
// 01->1
// 10->0
// 11->0
// output = ~a

wire out_10 = ~a;

// 2-bit cd input
wire [1:0] cd = {c, d};

// Use a 4-to-1 multiplexer based on cd
assign out = (cd == 2'b00) ? out_00 :
             (cd == 2'b01) ? out_01 :
             (cd == 2'b11) ? out_11 :
             (cd == 2'b10) ? out_10 :
             1'b0; // default, shouldn't happen

endmodule