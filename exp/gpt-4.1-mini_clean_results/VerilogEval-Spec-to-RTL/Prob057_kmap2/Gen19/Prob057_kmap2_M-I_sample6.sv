module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    wire not_a = ~a;
    wire not_b = ~b;
    wire not_c = ~c;
    wire not_d = ~d;

    // out = (~c & ~d) | (~a & ~b) | (c & d & (a | b)) | (c & ~d & ~a)
    assign out = (not_c & not_d) 
                 | (not_a & not_b) 
                 | (c & d & (a | b)) 
                 | (c & not_d & not_a);
endmodule