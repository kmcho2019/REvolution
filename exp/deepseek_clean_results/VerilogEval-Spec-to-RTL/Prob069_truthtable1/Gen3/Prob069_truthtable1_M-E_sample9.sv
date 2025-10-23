module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // First level mux: select between x1 and x2 based on x3
    wire mux1_out = x3 ? x1 : x2;
    
    // Second level mux: implement the remaining truth table conditions
    assign f = (x3 & ~x2) ? x1 : 
               (~x3 & ~x2) ? 1'b0 : 
               mux1_out;
endmodule