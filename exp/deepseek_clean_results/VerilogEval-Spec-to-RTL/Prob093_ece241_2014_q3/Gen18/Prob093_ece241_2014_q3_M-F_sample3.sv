module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = d | (~d & c);  // 1 when d=1 or (d=0 and c=1)
    assign mux_in[1] = 1'b0;          // Always 0
    assign mux_in[2] = c & d;         // Only 1 when both c and d are 1
    assign mux_in[3] = ~d | c;        // 1 when d=0 or c=1

endmodule