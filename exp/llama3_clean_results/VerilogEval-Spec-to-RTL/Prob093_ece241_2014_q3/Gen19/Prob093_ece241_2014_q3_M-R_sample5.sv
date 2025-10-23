module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Implement mux_in[0] based on cd = 10
    assign mux_in[0] = (!c && d);

    // Set mux_in[1] to '0'
    assign mux_in[1] = 1'b0;

    // Implement mux_in[2] based on c = 1
    assign mux_in[2] = c;

    // Implement mux_in[3] based on c = 1
    assign mux_in[3] = c;

endmodule