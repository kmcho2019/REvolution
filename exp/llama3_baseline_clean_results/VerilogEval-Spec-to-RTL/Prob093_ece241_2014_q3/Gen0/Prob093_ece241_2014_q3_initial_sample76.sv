module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    wire m0, m1, m2, m3;

    // Generate mux_in[0]
    assign m0 = (c == 0 && d == 0) ? 1'b0 : (c == 1 && d == 1) ? 1'b1 : 1'b0;

    // Generate mux_in[1]
    assign m1 = (c == 0 && d == 1) ? 1'b0 : (c == 1 && d == 0) ? 1'b0 : (c == 1 && d == 1) ? 1'b0 : 1'b0;

    // Generate mux_in[2]
    assign m2 = (c == 0 && d == 1) ? 1'b0 : (c == 1 && d == 0) ? 1'b0 : (c == 1 && d == 1) ? 1'b1 : 1'b0;

    // Generate mux_in[3]
    assign m3 = (c == 0 && d == 0) ? 1'b1 : (c == 0 && d == 1) ? 1'b0 : (c == 1 && d == 0) ? 1'b0 : (c == 1 && d == 1) ? 1'b1 : 1'b0;

    assign mux_in = {m3, m2, m1, m0};
endmodule