module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Directly implement the logic for each mux_in based on the Karnaugh map
    assign mux_in[0] = (~c) & d;  // Logic for ab = 00
    assign mux_in[1] = c & (~d);  // Logic for ab = 01
    assign mux_in[2] = c;         // Simplified logic for ab = 11
    assign mux_in[3] = c | d;     // Simplified logic for ab = 10
endmodule