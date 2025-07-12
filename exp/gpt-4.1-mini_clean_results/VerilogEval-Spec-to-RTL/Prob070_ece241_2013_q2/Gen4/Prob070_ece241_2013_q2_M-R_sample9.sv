module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Pack inputs into a 4-bit vector for easy comparison
    wire [3:0] in_vec;
    assign in_vec = {a,b,c,d};

    // Define outputs by explicitly checking input values
    // For out_sop, output is 1 if input equals 2, 7, or 15
    assign out_sop = (in_vec == 4'd2) | (in_vec == 4'd7) | (in_vec == 4'd15);

    // For out_pos, output is 1 except when input equals the zeros (0,1,4,5,6,9,10,13,14)
    // which correspond to output zero
    assign out_pos = ~((in_vec == 4'd0) | (in_vec == 4'd1) | (in_vec == 4'd4) | 
                       (in_vec == 4'd5) | (in_vec == 4'd6) | (in_vec == 4'd9) | 
                       (in_vec == 4'd10) | (in_vec == 4'd13) | (in_vec == 4'd14));

endmodule