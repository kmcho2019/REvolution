module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = (!c) && d; // For ab = 00, d and not c
    assign mux_in[1] = 1'b0; // For ab = 01, output is always 0
    assign mux_in[2] = d; // For ab = 11, output is d
    assign mux_in[3] = (!c) && d; // For ab = 10, same as ab = 00

    // Alternatively, to optimize and explicitly use a 2-to-1 mux
    wire temp;
    assign temp = (!c) && d;
    assign mux_in[0] = temp;
    assign mux_in[3] = temp;
endmodule