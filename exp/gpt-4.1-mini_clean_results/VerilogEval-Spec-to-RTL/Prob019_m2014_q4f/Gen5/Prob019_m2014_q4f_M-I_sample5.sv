module TopModule(
    input in1,
    input in2,
    output out
);
    wire inv_in2;
    not u_not(inv_in2, in2);
    and u_and(out, in1, inv_in2);
endmodule