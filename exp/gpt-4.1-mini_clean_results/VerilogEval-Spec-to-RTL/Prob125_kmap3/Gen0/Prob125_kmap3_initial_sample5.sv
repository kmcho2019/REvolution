module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Map inputs to ab and cd for clarity
    wire [1:0] ab = {a,b};
    wire [1:0] cd = {c,d};

    // Karnaugh map from problem:
    // ab\cd  00 01 11 10  (columns: ab 01 00 10 11 reordered to standard for easier logic)
    // cd=00: d=don't care, 0, 1, 1
    // cd=01: 0, 0, d, d
    // cd=11: 0, 1, 1, 1
    // cd=10: 0, 1, 1, 1
    //
    // Let's write minterms where output = 1 (including don't care as 0 or 1 to simplify)
    // For simplicity, let's list out terms corresponding to each (cd, ab) with 1's:
    // ab=00 (a=0,b=0), ab=01(a=0,b=1), ab=10(a=1,b=0), ab=11(a=1,b=1)
    //
    // Using the given map (rearranged for clarity):
    // cd=00(0,0): d(unknown), 0, 1, 1 -> for ab=10(1,0) and 11(1,1) output=1 when cd=00
    // cd=01(0,1): 0, 0, d, d -> output=0 or don't care, so ignore 1's here
    // cd=11(1,1): 0, 1, 1, 1 -> for ab=01(0,1), 10(1,0), 11(1,1) output=1 when cd=11
    // cd=10(1,0): 0, 1, 1, 1 -> for ab=01(0,1), 10(1,0), 11(1,1) output=1 when cd=10
    //
    // From this:
    // Output=1 when:
    // - cd=00 and ab=10 or 11
    // - cd=11 or cd=10 and ab=01 or 10 or 11
    //
    // Let's write boolean expression:
    // out = ( ~c & ~d & (a & ~b | a & b) )   // cd=00, ab=10 or 11
    //     | ( (c & d | c & ~d) & ( ~a & b | a & ~b | a & b) )  // cd=11 or 10, ab=01 or 10 or 11
    //
    // Simplify cd terms:
    // cd=11(1,1) or cd=10(1,0) => c=1 & (d or ~d) => just c=1
    // ab=01 or 10 or 11 => b or a (since ab=01=0,1; 10=1,0; 11=1,1)
    // Expression simplifies:
    // out = (~c & ~d & a) | (c & (a | b))
    //
    // Implement this expression directly.

    assign out = (~c & ~d & a) | (c & (a | b));

endmodule