module Buffer1 (
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

    Buffer1 buf_w (.in(a), .out(w));
    Buffer1 buf_x (.in(b), .out(x));
    Buffer1 buf_y (.in(b), .out(y));
    Buffer1 buf_z (.in(c), .out(z));

endmodule