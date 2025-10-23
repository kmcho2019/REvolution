module TopModule(a, b, c, d, out);
    input a;
    input b;
    input c;
    input d;
    output out;

    assign out = (c & (a | b)) | (~c & (~a & ~b) & ~(a & b)) | (~c & (a | b));
    // Or more simply, since d is don't-care and doesn't affect the outcome
    // assign out = (c & (a | b)) | (~c & ((~a & ~b)' | (a | b)));
    // A more optimal solution, simplified from Karnaugh map
    assign out = (a | b) & (c | ~a | ~b);

endmodule