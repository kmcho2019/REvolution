module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Directly assigning the Karnaugh map logic to mux_in
    assign mux_in[0] = d;            // For ab = 00, output is 1 when d is 1
    assign mux_in[1] = c && d;        // For ab = 01, output is 1 only when c and d are both 1
    assign mux_in[2] = d;            // For ab = 11, output is 1 when d is 1
    assign mux_in[3] = d;            // For ab = 10, output is 1 when d is 1
endmodule