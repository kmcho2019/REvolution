module TopModule(
    input  logic in,
    output logic out
);
    always_latch
        out = in;
endmodule