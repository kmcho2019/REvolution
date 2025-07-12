module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products implementation using multiplexer concept
    assign out_sop = a ? (b & c & d) :  // When a=1, only 15 (1111) matches
                    ((~b & c & ~d) | (b & c & d));  // When a=0, 2 (0010) or 7 (0111)

    // Product-of-sums implementation using priority conditions
    assign out_pos = ~(
        // Cases where output should be 0
        (~a & ~b & ~c & ~d) |  // 0
        (~a & ~b & ~c & d)  |   // 1
        (~a & b & ~c & ~d)  |   // 4
        (~a & b & ~c & d)   |   // 5
        (~a & b & c & ~d)    |  // 6
        (a & ~b & ~c & d)    |  // 9
        (a & ~b & c & ~d)    |  // 10
        (a & b & ~c & d)      | // 13
        (a & b & c & ~d)       // 14
    );

endmodule