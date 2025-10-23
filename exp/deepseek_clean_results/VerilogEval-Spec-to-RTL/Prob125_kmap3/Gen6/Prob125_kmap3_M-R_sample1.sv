module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Combine ab and cd for easier pattern matching
    wire [1:0] ab = {a, b};
    wire [1:0] cd = {c, d};

    // Main logic:
    // 1. Output 1 when c is high (except ab=00 & cd=01)
    // 2. Output 1 when ab is 10 or 11
    // 3. Output 1 when ab=00 and cd is 10 or 11
    assign out = (c & ~(ab == 2'b00 & cd == 2'b01)) |  // Case 1
                 (ab[1]) |                            // Case 2 (ab=10 or 11)
                 (ab == 2'b00 & (cd == 2'b10 | cd == 2'b11));  // Case 3
endmodule