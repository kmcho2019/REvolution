module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

    // 2-to-1 multiplexer function
    function mux2;
        input sel;
        input d1;
        input d0;
        begin
            mux2 = sel ? d1 : d0;
        end
    endfunction

    // mux_in[0]: cd=00,01,11,10 => 0,0,0,1
    // Implementation: mux_in[0] = mux2(c, mux2(d,1'b1,1'b0), 1'b0);
    assign mux_in[0] = mux2(c, mux2(d, 1'b1, 1'b0), 1'b0);

    // mux_in[1]: all zeros
    assign mux_in[1] = 1'b0;

    // mux_in[2]: cd=00,01,11,10 => 0,0,1,0
    // Implementation: mux_in[2] = mux2(c, mux2(d, 1'b1, 1'b0), 1'b0);
    assign mux_in[2] = mux2(c, mux2(d, 1'b1, 1'b0), 1'b0);

    // mux_in[3]: cd=00,01,11,10 => 1,0,1,1
    // Implementation: mux_in[3] = mux2(c, 1'b1, mux2(d, 1'b0, 1'b1));
    assign mux_in[3] = mux2(c, 1'b1, mux2(d, 1'b0, 1'b1));

endmodule