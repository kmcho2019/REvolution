module buf1 (input in, output out);
    assign out = in;
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    // Instantiate buffers connecting inputs directly to outputs without intermediate wires
    buf1 buf_w (.in(a), .out(w));
    buf1 buf_x (.in(b), .out(x));
    buf1 buf_y (.in(b), .out(y));
    buf1 buf_z (.in(c), .out(z));

endmodule