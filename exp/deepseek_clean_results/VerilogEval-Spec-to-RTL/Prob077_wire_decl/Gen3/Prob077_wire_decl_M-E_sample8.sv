module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // Intermediate nets
    wire net1, net2;
    
    // First layer: AND gates using primitive instantiations
    and AND1(net1, a, b);
    and AND2(net2, c, d);
    
    // Second layer: OR gate using primitive instantiation
    or OR1(out, net1, net2);
    
    // Inverted output
    assign out_n = ~out;

endmodule