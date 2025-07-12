module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products implementation for out_sop
    // out_sop = a'b'cd' (2) + a'bcd (7) + abcd (15)
    assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

    // Product-of-sums implementation for out_pos
    // out_pos = (a+b+c+d)(a+b+c+d')(a+b'+c+d)(a+b'+c+d')(a+b'+c'+d)(a'+b+c+d')(a'+b+c'+d)(a'+b'+c+d')(a'+b'+c'+d)
    assign out_pos = (a | b | c | d) &
                     (a | b | c | ~d) &
                     (a | ~b | c | d) &
                     (a | ~b | c | ~d) &
                     (a | ~b | ~c | d) &
                     (~a | b | c | ~d) &
                     (~a | b | ~c | d) &
                     (~a | ~b | c | ~d) &
                     (~a | ~b | ~c | d);

endmodule