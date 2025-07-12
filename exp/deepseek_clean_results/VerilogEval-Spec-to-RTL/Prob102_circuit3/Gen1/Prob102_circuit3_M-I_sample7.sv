module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Implement (a OR b) AND (c OR d) using OAI22 + INV
    wire oai22_out;
    OAI22X1 oai22 (.A0(a), .A1(b), .B0(c), .B1(d), .Y(oai22_out));
    INVX1 inv (.A(oai22_out), .Y(q));
endmodule