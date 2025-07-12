module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Minimal SOP implementation from K-map analysis
assign out = (~a & ~b) |               // a'b' term
             (~a & c) |                // a'c term
             (b & c & ~d) |            // bcd' term
             (a & ~c & d);             // ac'd term

endmodule