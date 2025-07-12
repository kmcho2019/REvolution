module TopModule (
    input in1,
    input in2,
    output out
);
    wire in2_not;
    
    not inv1(in2_not, in2);
    and and1(out, in1, in2_not);
endmodule