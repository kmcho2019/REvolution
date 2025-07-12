module TopModule (
    input a,
    input b,
    output out
);
    wire w1, w2;
    
    // PMOS transistors (active low)
    assign w1 = (a === 1'b0) ? 1'b1 : 1'bz;
    assign w2 = (b === 1'b0) ? 1'b1 : 1'bz;
    
    // NMOS transistors (active high)
    assign out = (a === 1'b1 || b === 1'b1) ? 1'b0 : (w1 & w2);
    
endmodule