module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Intermediate wires for each cd row (c,d) in the Karnaugh map
wire cd_00; // c=0, d=0
wire cd_01; // c=0, d=1
wire cd_11; // c=1, d=1
wire cd_10; // c=1, d=0

// ab combinations for each cd combination from Karnaugh map:

// cd=00 row: ab=00(1),01(1),11(0),10(1)
// ab: a=MSB, b=LSB
wire ab_00 = ~a & ~b; // ab=00
wire ab_01 = ~a & b;  // ab=01
wire ab_11 = a & b;   // ab=11
wire ab_10 = a & ~b;  // ab=10

assign cd_00 = ab_00 | ab_01 | /* ab_11=0 excluded */ ab_10; // 1|1|0|1 = 1

// cd=01 row: ab=00(1),01(0),11(0),10(1)
assign cd_01 = ab_00 | /* ab_01=0 */ 1'b0 | /* ab_11=0 */ 1'b0 | ab_10;

// cd=11 row: ab=00(0),01(1),11(1),10(1)
assign cd_11 = /* ab_00=0 */ 1'b0 | ab_01 | ab_11 | ab_10;

// cd=10 row: ab=00(1),01(1),11(0),10(0)
assign cd_10 = ab_00 | ab_01 | /* ab_11=0 */ 1'b0 | /* ab_10=0 */ 1'b0;

// Now select rows according to c,d values
// Use c and d directly as selectors to pick the correct row
wire c0 = ~c;
wire d0 = ~d;

// The final output is true if for the current (c,d) combination, the respective cd_xx output is true.

// Multiplexer for cd rows:
wire out_cd_00 = cd_00 & c0 & d0;
wire out_cd_01 = cd_01 & c0 & d;
wire out_cd_11 = cd_11 & c & d;
wire out_cd_10 = cd_10 & c & d0;

assign out = out_cd_00 | out_cd_01 | out_cd_11 | out_cd_10;

endmodule