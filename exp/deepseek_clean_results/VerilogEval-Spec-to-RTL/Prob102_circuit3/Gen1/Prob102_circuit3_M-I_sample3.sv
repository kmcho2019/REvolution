module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Implemented as OAI22 structure
    assign q = ~((~(a | b)) | (~(c | d)));
endmodule