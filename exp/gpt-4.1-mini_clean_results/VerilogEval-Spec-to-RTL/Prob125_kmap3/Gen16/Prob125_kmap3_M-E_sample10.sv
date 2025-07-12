module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

wire [3:0] in_vec = {c, d, a, b};

// Define minterm checks corresponding to the Karnaugh map cells set to 1:
// Minterms: (cdab)
// 0001 (c=0,d=0,a=1,b=0) -> 0 0 1 0 = 2 (not 1) corrected below
// According to map and the question:
// Output = 1 for:
// cd ab
// 00 10 -> 0 0 1 0 = 2
// 00 11 -> 0 0 1 1 = 3
// 11 00 -> 1 1 0 0 = 12
// 11 10 -> 1 1 1 0 = 14
// 11 11 -> 1 1 1 1 = 15
// 10 00 -> 1 0 0 0 = 8
// 10 10 -> 1 0 1 0 = 10
// 10 11 -> 1 0 1 1 = 11

// Create wires for each minterm and OR them
wire m2  = (in_vec == 4'd2);
wire m3  = (in_vec == 4'd3);
wire m8  = (in_vec == 4'd8);
wire m10 = (in_vec == 4'd10);
wire m11 = (in_vec == 4'd11);
wire m12 = (in_vec == 4'd12);
wire m14 = (in_vec == 4'd14);
wire m15 = (in_vec == 4'd15);

assign out = m2 | m3 | m8 | m10 | m11 | m12 | m14 | m15;

endmodule