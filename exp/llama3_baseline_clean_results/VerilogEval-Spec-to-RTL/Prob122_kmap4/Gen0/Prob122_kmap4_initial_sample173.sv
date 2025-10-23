module TopModule(a, b, c, d, out);
    input a, b, c, d;
    output out;

    assign out = (~c & ~d & b) | 
                  (c & ~d & ~b & a) | 
                  (c & d & ~a & ~b) | 
                  (~c & d & b & a);

endmodule