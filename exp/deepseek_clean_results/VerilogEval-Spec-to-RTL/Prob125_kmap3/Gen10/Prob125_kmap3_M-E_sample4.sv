module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire mux_input1 = a;
    wire mux_input0 = a | ~b;
    
    assign out = c ? mux_input0 : mux_input1;
endmodule