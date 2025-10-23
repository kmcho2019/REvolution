module TopModule(
    input d,
    input ena,
    output q
);
    // D latch implementation: q follows d when enabled, holds otherwise
    assign q = ena ? d : q;
endmodule