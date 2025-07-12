module TopModule(
    input  a,  // MSB
    input  b,
    input  c,
    input  d,  // LSB
    output out_sop,
    output out_pos
);

    // Combine inputs into a 4-bit vector, MSB to LSB: a b c d
    wire [3:0] in_vec = {a, b, c, d};

    // Define wires for each relevant number by comparing in_vec to constants
    wire is_0  = (in_vec == 4'd0);
    wire is_1  = (in_vec == 4'd1);
    wire is_2  = (in_vec == 4'd2);
    wire is_3  = (in_vec == 4'd3);
    wire is_4  = (in_vec == 4'd4);
    wire is_5  = (in_vec == 4'd5);
    wire is_6  = (in_vec == 4'd6);
    wire is_7  = (in_vec == 4'd7);
    wire is_8  = (in_vec == 4'd8);
    wire is_9  = (in_vec == 4'd9);
    wire is_10 = (in_vec == 4'd10);
    wire is_11 = (in_vec == 4'd11);
    wire is_12 = (in_vec == 4'd12);
    wire is_13 = (in_vec == 4'd13);
    wire is_14 = (in_vec == 4'd14);
    wire is_15 = (in_vec == 4'd15);

    // Out_sop should be 1 for inputs 2,7,15
    assign out_sop = is_2 | is_7 | is_15;

    // Out_pos should be 0 for inputs 2,7,15 and 1 for specified zeros (0,1,4,5,6,9,10,13,14)
    // Since out_pos is active low for those inputs, invert that logic:
    // out_pos = AND of maxterms corresponding to zeros, i.e., 1 for zero inputs, 0 for one inputs
    assign out_pos = (is_0 | is_1 | is_4 | is_5 | is_6 | is_9 | is_10 | is_13 | is_14);

endmodule