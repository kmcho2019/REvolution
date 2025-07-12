module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    wire mux_select;
    wire mux_out0, mux_out1;
    
    assign mux_select = x3;
    assign mux_out0 = x2;  // x3=0 case
    assign mux_out1 = x1;  // x3=1 case
    assign f = mux_select ? mux_out1 : mux_out0;
endmodule