module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Concatenate inputs to form 4-bit number: a as MSB, d as LSB
    wire [3:0] num = {a,b,c,d};

    // Define minterms for outputs = 1: decimal 2,7,15
    wire is_2  = (num == 4'd2);
    wire is_7  = (num == 4'd7);
    wire is_15 = (num == 4'd15);

    // out_sop: sum of minterms = 2 + 7 + 15
    assign out_sop = is_2 | is_7 | is_15;

    // Define maxterms for outputs = 0: 0,1,4,5,6,9,10,13,14
    // Out_pos = product of sums of zeros, so it's low if any zero maxterm matched.
    wire is_0  = (num == 4'd0);
    wire is_1  = (num == 4'd1);
    wire is_4  = (num == 4'd4);
    wire is_5  = (num == 4'd5);
    wire is_6  = (num == 4'd6);
    wire is_9  = (num == 4'd9);
    wire is_10 = (num == 4'd10);
    wire is_13 = (num == 4'd13);
    wire is_14 = (num == 4'd14);

    // The output out_pos must be '1' only if input is NOT one of these zero values
    // But only 2,7,15 map to 1, and 3,8,11,12 never occur.
    // Implement the minimal product-of-sums by excluding zero maxterms:
    // out_pos = NAND of zero maxterms (in POS form)
    assign out_pos = ~(
          is_0
        | is_1
        | is_4
        | is_5
        | is_6
        | is_9
        | is_10
        | is_13
        | is_14
    );

endmodule