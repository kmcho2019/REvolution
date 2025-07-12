module TopModule (
    input a,
    input b,
    output out
);
    // Alternative XNOR implementation using basic gates
    assign out = (a & b) | (~a & ~b);
endmodule