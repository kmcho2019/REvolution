module TopModule (
    input d,
    input ena,
    output q
);

// D latch implementation: q follows d when enabled, holds value otherwise
assign q = ena ? d : q;  // Feedback path is implicit in this implementation

endmodule