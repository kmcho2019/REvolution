module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire mux_out;
    
    // First level mux: select between c and 0 based on b
    assign mux_out = b ? 1'b0 : c;
    
    // Second level mux: select between 1 and first mux output based on a
    assign out = a ? 1'b1 : mux_out;
endmodule