module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

// 2-to-1 mux: out = sel ? in1 : in0
function mux2;
    input sel, in0, in1;
    begin
        mux2 = sel ? in1 : in0;
    end
endfunction

assign mux_in[0] = mux2(d, c, 1'b1);   // mux_in[0] = d ? 1 : c
assign mux_in[1] = 1'b0;                // mux_in[1] = 0
assign mux_in[2] = mux2(c, 1'b0, d);   // mux_in[2] = c ? d : 0
assign mux_in[3] = mux2(d, 1'b1, c);   // mux_in[3] = d ? c : 1

endmodule