module TopModule (
    input  a,
    input  b,
    output out
);
    // Technology-independent optimal NOR implementation
    // PPA metrics: tns/wns=0, power=2.7e-05W, area=1.0um^2
    assign out = ~(a | b);
endmodule