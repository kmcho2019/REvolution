module TopModule (
    input d,
    input ena,
    output q
);

assign q = ena ? d : q;  // Basic D latch implementation

endmodule