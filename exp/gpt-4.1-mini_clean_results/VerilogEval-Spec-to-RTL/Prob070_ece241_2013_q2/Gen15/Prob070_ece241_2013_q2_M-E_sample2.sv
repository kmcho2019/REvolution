module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Compose 4-bit input as a vector
    wire [3:0] in_vec = {a,b,c,d};

    // Define constants for the numbers to detect
    localparam [3:0] NUM_2  = 4'b0010;
    localparam [3:0] NUM_7  = 4'b0111;
    localparam [3:0] NUM_15 = 4'b1111;

    // out_sop = 1 if input equals 2, 7, or 15; else 0
    assign out_sop = (in_vec == NUM_2) | (in_vec == NUM_7) | (in_vec == NUM_15);

    // out_pos = product of sums form for zeros; since inputs 3,8,11,12 never occur,
    // and outputs 1 only at 2,7,15, out_pos = ~out_sop, 
    // which is minimal product of sums by definition here.
    assign out_pos = ~out_sop;

endmodule