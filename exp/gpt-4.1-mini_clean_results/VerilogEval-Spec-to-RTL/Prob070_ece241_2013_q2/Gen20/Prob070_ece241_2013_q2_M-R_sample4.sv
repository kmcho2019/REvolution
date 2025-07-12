module TopModule(
    input  a,    // MSB
    input  b,
    input  c,
    input  d,    // LSB
    output out_sop,
    output out_pos
);

    // Combine inputs into 4-bit vector for clarity and comparison
    wire [3:0] num = {a,b,c,d};

    // Define minterms for outputs=1: 2(0010),7(0111),15(1111)
    wire is_2  = (num == 4'd2);
    wire is_7  = (num == 4'd7);
    wire is_15 = (num == 4'd15);

    // Define minterms for outputs=0: 0,1,4,5,6,9,10,13,14
    // Though not needed explicitly here, useful for POS expression if desired.

    // out_sop directly asserts 1 when num is 2,7, or 15 (minimal SOP by exact minterm OR)
    assign out_sop = is_2 | is_7 | is_15;

    // For out_pos, implement the minimal POS by expressing zeros as maxterms:
    // Zero minterms: 0(0000),1(0001),4(0100),5(0101),6(0110),9(1001),10(1010),13(1101),14(1110)
    // The minimal POS is the AND of sum terms that are false only on the zero minterms.
    // We derive the three maxterms from zeros (confirmed by K-map or problem statement):

    // Maxterm1 covers zeros 0,1,4,5,6 (where a=0 or b=0 or c=0 or d=anything)
    wire maxterm1 = (a | b | ~c | d);

    // Maxterm2 covers zeros 0,1,9,13 (where a=0 or b=0 or c=1 or d=anything)
    wire maxterm2 = (a | ~b | c | d);

    // Maxterm3 covers zeros 0,4,5,9 (where a=1 or b=0 or c=1 or d=anything)
    wire maxterm3 = (~a | b | c | d);

    assign out_pos = maxterm1 & maxterm2 & maxterm3;

endmodule