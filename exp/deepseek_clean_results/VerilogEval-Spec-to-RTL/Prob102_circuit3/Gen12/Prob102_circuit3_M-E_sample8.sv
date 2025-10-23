module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire select_ab = a | b;
    wire mux1_out = d ? 1'b1 : c;
    wire mux2_out = select_ab ? mux1_out : 1'b0;
    
    assign q = mux2_out;

endmodule