// TopModule: A combinational circuit implementing an AND gate.
module TopModule(
    input  a,  
    input  b,  
    output q   
);
assign q = a & b;
endmodule