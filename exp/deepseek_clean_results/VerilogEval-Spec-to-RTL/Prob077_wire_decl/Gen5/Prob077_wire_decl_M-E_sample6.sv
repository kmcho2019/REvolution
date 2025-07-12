module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    wire and1 = a & b;
    wire and2 = c & d;
    
    // MUX-based implementation
    assign out = (and1 | and2) ? 1'b1 : (a | b | c | d);
    assign out_n = ~out;

endmodule