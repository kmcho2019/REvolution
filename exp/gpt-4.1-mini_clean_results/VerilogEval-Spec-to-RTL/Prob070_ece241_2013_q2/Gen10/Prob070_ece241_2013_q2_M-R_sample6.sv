module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Define the 4-bit input vector (a is MSB, d is LSB)
    wire [3:0] num = {a, b, c, d};

    // Decimal values in binary (a,b,c,d):
    //  2 = 0 0 1 0
    //  7 = 0 1 1 1
    // 15 = 1 1 1 1

    // Minimal SOP for out_sop is sum of minterms for 2,7,15:
    // out_sop = (num == 4'd2) | (num == 4'd7) | (num == 4'd15)
    assign out_sop = (num == 4'd2) | (num == 4'd7) | (num == 4'd15);

    // Minimal POS for out_pos from zeros at 0,1,4,5,6,9,10,13,14 with don't-cares 3,8,11,12:
    // out_pos = (a + b + ~c + d) & (a + ~b + c + d) & (~a + b + c + ~d)
    wire clause1 = a | b | ~c | d;
    wire clause2 = a | ~b | c | d;
    wire clause3 = ~a | b | c | ~d;

    assign out_pos = clause1 & clause2 & clause3;

endmodule