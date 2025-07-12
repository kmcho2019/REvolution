module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire or_bc;
    wire mux_out;

    assign or_bc = b | c;
    assign mux_out = a ? 1'b1 : or_bc;
    assign out = mux_out;
endmodule