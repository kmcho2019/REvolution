module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    wire [3:0] num = {a,b,c,d};

    // Explicit minterm checks for 2, 7, 15
    wire is_2  = (num == 4'd2);
    wire is_7  = (num == 4'd7);
    wire is_15 = (num == 4'd15);

    // out_sop is 1 when num is 2, 7, or 15
    assign out_sop = is_2 | is_7 | is_15;

    // out_pos is complement of out_sop
    assign out_pos = ~out_sop;

endmodule