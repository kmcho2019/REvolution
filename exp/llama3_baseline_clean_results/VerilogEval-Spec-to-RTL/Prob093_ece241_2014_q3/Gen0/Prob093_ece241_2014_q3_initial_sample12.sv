module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Using 2-to-1 multiplexers to generate outputs
    // For a=0, b=0 (mux_in[0])
    // Since both c=0 and c=1 have the same output for a=0, b=0, we directly assign
    assign mux_in[0] = d;

    // For a=0, b=1 (mux_in[1])
    assign mux_in[1] = 1'b0;

    // For a=1, b=0 (mux_in[2])
    assign mux_in[2] = d;

    // For a=1, b=1 (mux_in[3])
    assign mux_in[3] = d;
endmodule