module TopModule(
    input d,
    input ena,
    output q
);
    assign q = ena ? d : q;
endmodule