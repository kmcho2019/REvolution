module TopModule(a, b, c, d, out);
    input a, b, c, d;
    output out;

    // The Karnaugh map simplifies to: out = (b & (a | ~c)) | (~a & ~b & ~c)
    // However, to accurately reflect the map and simplify, focusing on 'b' being 1 and its conditions
    assign out = (b & (a | ~c));
endmodule