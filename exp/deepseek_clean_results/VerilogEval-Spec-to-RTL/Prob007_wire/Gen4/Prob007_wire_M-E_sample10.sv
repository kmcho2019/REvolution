module TopModule (
    input in,
    output out
);
    tranif1 t1(out, in, 1'b1);  // PMOS transmission gate always enabled
    tranif0 t0(out, in, 1'b0);  // NMOS transmission gate always enabled
endmodule