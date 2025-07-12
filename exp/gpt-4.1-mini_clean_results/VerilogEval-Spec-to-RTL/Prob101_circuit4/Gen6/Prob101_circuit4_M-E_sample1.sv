module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire mux_out;

    // 2-to-1 MUX selects b or c based on a
    assign mux_out = a ? c : b;

    // OR mux_out with 0 (from d & 0) just for structure variety
    assign q = mux_out | (d & 1'b0);

endmodule