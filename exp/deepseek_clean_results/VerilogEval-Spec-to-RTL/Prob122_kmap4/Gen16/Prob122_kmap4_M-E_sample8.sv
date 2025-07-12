module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire mux1_out;
    wire mux2_out;
    
    // First level muxes select between the checkerboard patterns
    assign mux1_out = a ? ~b : b;
    assign mux2_out = a ? b : ~b;
    
    // Final mux selects between the two patterns based on c
    assign out = c ? mux2_out : mux1_out;
    
endmodule