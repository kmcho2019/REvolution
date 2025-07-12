module TopModule (
    input  a,
    input  b,
    output out
);
    wire or_out;

    or u_or(or_out, a, b);   // OR gate instantiation
    not u_not(out, or_out);  // NOT gate instantiation to get NOR
endmodule