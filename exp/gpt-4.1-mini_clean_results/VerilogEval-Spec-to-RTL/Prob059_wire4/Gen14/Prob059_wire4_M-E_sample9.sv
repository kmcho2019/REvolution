module Buffer (
    input  wire in,
    output wire out
);
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

    Buffer buf_w (.in(a), .out(w));
    Buffer buf_x (.in(b), .out(x));
    Buffer buf_y (.in(b), .out(y));
    Buffer buf_z (.in(c), .out(z));

endmodule