module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = ~c & d;    // Only 1 when c=0 and d=1 (cd=10)
    assign mux_in[1] = 1'b0;      // Always 0
    assign mux_in[2] = ~d | c;    // 1 when d=0 or c=1
    assign mux_in[3] = ~c | d;    // 1 unless c=1 and d=0

endmodule