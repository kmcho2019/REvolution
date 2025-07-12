module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care
    output out
);

// Select lines for MUX
wire [1:0] sel = {b, a}; // b is MSB, a is LSB

// Define inputs to 4-to-1 MUX based on c and d for each combination of b,a
// According to the Karnaugh map rows for c,d combined:

// For sel=00 (b=0,a=0): K-map cells for ab=00 are 0 (cd=00:0), 0(01:0), 1(10:1), 1(11:1)
// But we are using c,d as inputs (2 bits), map cd:
// cd=00:0, cd=01:0, cd=10:1, cd=11:1
// So output = (c & d) | (c & ~d) = c
wire in0 = c;  

// For sel=01 (b=0,a=1): ab=01: cells are d(00:d),0(01:0),1(10:1),1(11:1)
// We pick d as 0 for don't care to simplify
// cd=00:d(choose 0), 01:0, 10:1, 11:1
// output = (~c & ~d) *0 + (~c & d)*0 + (c & ~d)*1 + (c & d)*1 = c
wire in1 = c;

// For sel=10 (b=1,a=0): ab=10: cells are 1(00:1), d(01:d), 1(10:1), 1(11:1)
// Take d=1
// cd=00:1, 01:d=1, 10:1, 11:1
// So output = 1
wire in2 = 1'b1;

// For sel=11 (b=1,a=1): ab=11: cells are 1(00:1), d(01:d), 1(10:1), 1(11:1)
// Similarly, output = 1
wire in3 = 1'b1;

// 4-to-1 MUX implementation
assign out = (sel == 2'b00) ? in0 :
             (sel == 2'b01) ? in1 :
             (sel == 2'b10) ? in2 :
                              in3;

endmodule