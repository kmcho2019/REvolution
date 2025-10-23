module TopModule(a, b, c, d, out_sop, out_pos);
    input a;
    input b;
    input c;
    input d;
    output out_sop;
    output out_pos;

    assign out_sop = (b & ~a & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);
    assign out_pos = ~(~a & ~b & ~c & ~d) & ~(~a & ~b & ~c & d) & ~(~a & ~b & c & ~d) & ~(~a & b & ~c & ~d) & ~(~a & b & ~c & d) & ~(~a & b & c & ~d) & ~(a & ~b & ~c & d) & ~(a & ~b & c & ~d) & ~(a & b & ~c & d);

endmodule