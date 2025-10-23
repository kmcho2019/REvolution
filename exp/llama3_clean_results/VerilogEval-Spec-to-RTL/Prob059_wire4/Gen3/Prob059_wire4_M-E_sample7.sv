module WireModule(
    input  in_signal,
    output out_signal
);
    assign out_signal = in_signal;
endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    WireModule aw(.in_signal(a), .out_signal(w));
    WireModule bx(.in_signal(b), .out_signal(x));
    WireModule by(.in_signal(b), .out_signal(y));
    WireModule cz(.in_signal(c), .out_signal(z));
endmodule