module TopModule(a, b, c, d, out);
    input a, b, c, d;
    output out;
    assign out = (~c & ~d & b) | (c & ~d & a) | (~c & d & ~a) | (c & d & b);
endmodule