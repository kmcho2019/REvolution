module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic out
);

    logic cd_00, cd_01, cd_11, cd_10;
    logic out_cd_00, out_cd_01, out_cd_11, out_cd_10;

    // Decode cd values
    assign cd_00 = ~(c | d);
    assign cd_01 = c & ~d;
    assign cd_11 = c & d;
    assign cd_10 = ~c & d;

    // Determine output based on cd values and a, b
    assign out_cd_00 = a ^ b; // When cd = 00, out = a ^ b
    assign out_cd_01 = a ^ ~b; // When cd = 01, out = a ^ ~b
    assign out_cd_11 = a ^ ~b; // When cd = 11, out = a ^ ~b
    assign out_cd_10 = a ^ b; // When cd = 10, out = a ^ b

    // Final output based on decoded cd values
    assign out = (cd_00 & out_cd_00) | 
                 (cd_01 & out_cd_01) | 
                 (cd_11 & out_cd_11) | 
                 (cd_10 & out_cd_10);

endmodule