module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    assign out = {
        1'b1,        ~(a ^ b), ~(a ^ c), ~(a ^ d), ~(a ^ e),
        ~(b ^ a),    1'b1,     ~(b ^ c), ~(b ^ d), ~(b ^ e),
        ~(c ^ a),    ~(c ^ b), 1'b1,     ~(c ^ d), ~(c ^ e),
        ~(d ^ a),    ~(d ^ b), ~(d ^ c), 1'b1,     ~(d ^ e),
        ~(e ^ a),    ~(e ^ b), ~(e ^ c), ~(e ^ d), 1'b1
    };

endmodule