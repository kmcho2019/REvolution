module TopModule(input c, input d, output [3:0] mux_in);
    // 2-to-1 multiplexer
    // sel=select, i0=input0, i1=input1, y=output
    function mux2to1;
        input i0, i1, sel;
        begin
            mux2to1 = sel ? i1 : i0;
        end
    endfunction

    wire not_d;
    // not_d = ~d implemented using mux(1,0,d)
    assign not_d = mux2to1(1'b1, 1'b0, d);

    // mux_in[0] = c | d = mux(d,1,c)
    assign mux_in[0] = mux2to1(d, 1'b1, c);

    // mux_in[1] = 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c & d = mux(0,d,c)
    assign mux_in[2] = mux2to1(1'b0, d, c);

    // mux_in[3] = c | ~d = mux(not_d,1,c)
    assign mux_in[3] = mux2to1(not_d, 1'b1, c);

endmodule