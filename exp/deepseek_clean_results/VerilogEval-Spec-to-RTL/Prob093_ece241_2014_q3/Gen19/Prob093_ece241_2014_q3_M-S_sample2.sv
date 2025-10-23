module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = ~c | d;    // 0 only when c=1 and d=0
    assign mux_in[1] = 1'b0;      // Always 0
    assign mux_in[2] = c & d;     // Only 1 when both c and d are 1
    assign mux_in[3] = c | ~d;    // 1 when c=1 or d=0

endmodule