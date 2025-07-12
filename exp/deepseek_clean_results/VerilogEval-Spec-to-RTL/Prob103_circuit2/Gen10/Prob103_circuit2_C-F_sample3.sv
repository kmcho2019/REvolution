module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Optimal XOR-based implementation
    assign q = ~(a ^ b ^ c ^ d);

    // Verification assertions (synthesis will ignore)
    // These document all cases where output should be 1
    always @(*) begin
        if (~a & ~b & ~c & ~d) assert(q);         // 0000
        if (a & b & ~c & ~d) assert(q);           // 1100
        if (a & ~b & c & ~d) assert(q);           // 1010
        if (a & ~b & ~c & d) assert(q);           // 1001
        if (~a & b & c & ~d) assert(q);           // 0110
        if (~a & b & ~c & d) assert(q);           // 0101
        if (~a & ~b & c & d) assert(q);          // 0011
        if (a & b & c & d) assert(q);            // 1111
    end

endmodule