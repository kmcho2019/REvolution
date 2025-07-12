module TopModule (
    input a,
    input b,
    input c,
    output out
);
    wire bc_zero = ~(b | c);
    assign out = bc_zero ? a : 1'b1;
endmodule