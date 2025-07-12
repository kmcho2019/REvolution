module TopModule #(
    parameter WIDTH = 1
) (
    input wire a,
    input wire b,
    input wire sel,
    output wire out
);
    // Gate-level implementation
    wire sel_n;
    wire out_a, out_b;
    
    not(sel_n, sel);
    and(out_a, a, sel_n);
    and(out_b, b, sel);
    or(out, out_a, out_b);
endmodule