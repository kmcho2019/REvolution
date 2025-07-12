module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Mark unused inputs to avoid inferred logic
    wire unused_a = a;
    wire unused_d = d;
    // Synthesis directives (optional) to indicate unused signals
    // synthesis translate_off
    initial begin
        if (unused_a !== 1'bx) ;
        if (unused_d !== 1'bx) ;
    end
    // synthesis translate_on

    assign q = b | c;

endmodule