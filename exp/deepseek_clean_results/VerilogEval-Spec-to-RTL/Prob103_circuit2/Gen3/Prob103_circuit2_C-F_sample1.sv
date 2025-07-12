module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Optimal XOR-based even parity checker
    assign q = ~(a ^ b ^ c ^ d);

endmodule