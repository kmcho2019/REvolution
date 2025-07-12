module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Directly implement the conditions from the Karnaugh map
    assign mux_in[0] = ~c & d;  // For ab = 00, output is '1' when 'cd = 10'
    assign mux_in[1] = c ? 0 : d;  // For ab = 01, output is '1' when 'cd = 01'
    assign mux_in[2] = c | d;  // For ab = 11, output is 'c || d'
    assign mux_in[3] = c | d;  // For ab = 10, output is 'c || d'
endmodule