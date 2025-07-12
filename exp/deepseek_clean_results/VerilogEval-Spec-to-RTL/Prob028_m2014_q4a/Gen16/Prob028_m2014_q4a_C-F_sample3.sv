module TopModule (
    input d,
    input ena,
    output q
);

assign q = ena ? d : q;  // Optimal D latch implementation

endmodule