module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Generate input values for the multiplexer
    wire sel1, sel2;
    assign sel1 = d;
    assign sel2 = c;

    // 2-to-1 multiplexer for 'ab' equal to '00' and '01'
    assign mux_in[0] = (c == 1'b0 && d == 1'b0) ? 1'b0 : (c == 1'b0 && d == 1'b1) ? 1'b1 : (c == 1'b1 && d == 1'b0) ? 1'b1 : 1'b1;

    // 2-to-1 multiplexer for 'ab' equal to '01' and '11'
    assign mux_in[1] = (c == 1'b0 && d == 1'b0) ? 1'b0 : (c == 1'b0 && d == 1'b1) ? 1'b0 : (c == 1'b1 && d == 1'b0) ? 1'b0 : 1'b0;

    // 2-to-1 multiplexer for 'ab' equal to '11' and '10'
    assign mux_in[2] = (c == 1'b0 && d == 1'b0) ? 1'b0 : (c == 1'b0 && d == 1'b1) ? 1'b0 : (c == 1'b1 && d == 1'b0) ? 1'b0 : 1'b1;

    // 2-to-1 multiplexer for 'ab' equal to '10' and '11'
    assign mux_in[3] = (c == 1'b0 && d == 1'b0) ? 1'b1 : (c == 1'b0 && d == 1'b1) ? 1'b0 : (c == 1'b1 && d == 1'b0) ? 1'b1 : 1'b1;
endmodule