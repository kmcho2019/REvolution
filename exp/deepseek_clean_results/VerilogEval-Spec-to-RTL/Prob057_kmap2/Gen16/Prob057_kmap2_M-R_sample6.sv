module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Direct SOP implementation from K-map
assign out = (~a & ~b & ~c & ~d) |  // 0000
             (~a & ~b & ~c & d)  |  // 0001
             (~a & ~b & c & ~d)  |  // 0010
             (~a & b & ~c & ~d)  |  // 0100
             (~a & b & c & d)     |  // 0111
             (a & ~b & ~c & d)    |  // 1001
             (a & ~b & c & d)      |  // 1011
             (a & b & ~c & ~d)    |  // 1100
             (a & b & c & ~d)     |  // 1110
             (a & b & c & d);        // 1111

endmodule