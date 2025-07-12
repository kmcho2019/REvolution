module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Use b and c as select lines for 4:1 mux
    // Cases:
    // 00: output = a (since only case where output depends on a)
    // 01: output = 1
    // 10: output = 1
    // 11: output = 1
    assign out = (~b & ~c) ? a : 1'b1;
endmodule