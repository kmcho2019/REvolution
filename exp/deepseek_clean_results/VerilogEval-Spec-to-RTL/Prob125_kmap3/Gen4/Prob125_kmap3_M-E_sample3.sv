module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire cd_eq_00 = ~c & ~d;
    wire c0_case = (a & ~cd_eq_00) | ((a ^ b) & cd_eq_00);
    wire c1_case = a | b;
    assign out = c ? c1_case : c0_case;
endmodule