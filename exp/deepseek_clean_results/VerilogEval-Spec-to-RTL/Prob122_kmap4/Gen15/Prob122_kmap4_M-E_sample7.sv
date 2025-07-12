module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire mux1_out, mux2_out;
    
    // First level muxes
    assign mux1_out = a ? ~b : b;
    assign mux2_out = c ? ~d : d;
    
    // Final output selection
    assign out = (a ^ c) ? mux1_out : mux2_out;
endmodule