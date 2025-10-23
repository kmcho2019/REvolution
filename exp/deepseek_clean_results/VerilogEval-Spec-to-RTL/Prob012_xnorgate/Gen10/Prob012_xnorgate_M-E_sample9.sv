module TopModule (
    input a,
    input b,
    output out
);
    wire sel = a ^ b;  // XOR for mux select
    assign out = sel ? ~b : b;
endmodule