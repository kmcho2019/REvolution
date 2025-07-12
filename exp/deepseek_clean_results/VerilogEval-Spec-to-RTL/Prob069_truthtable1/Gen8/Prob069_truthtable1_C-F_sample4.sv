module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    wire mux_sel = x3;
    wire mux_in0 = x2;
    wire mux_in1 = x1;
    
    assign f = mux_sel ? mux_in1 : mux_in0;
endmodule