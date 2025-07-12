module TopModule (
    input a,
    input b,
    output out
);
    wire xor_ab = a ^ b;
    wire mux_out = xor_ab ? ~b : ~a;
    assign out = ~mux_out;
endmodule