module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // Pack inputs into a 4-bit vector for easy comparison
    wire [3:0] in_vec = {a, b, c, d};

    // out_sop is 1 when in_vec == 2, 7, or 15
    assign out_sop = (in_vec == 4'd2) | (in_vec == 4'd7) | (in_vec == 4'd15);

    // out_pos is complement of out_sop since zeros are all other valid inputs
    assign out_pos = ~out_sop;

endmodule