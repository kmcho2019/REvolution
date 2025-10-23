module TopModule(
    input  in,
    output out
);

not u_inv1 (.in(in), .out(out_buf));
not u_inv2 (.in(out_buf), .out(out));

endmodule

module not(
    input  in,
    output out
);

assign out = ~in;

endmodule