module TopModule(
    input  a,
    input  b,
    output reg out
);
    
    // Directly using the NOR operator or ensuring the expression is optimized
    always @(*) begin
        out = ~(a | b); // This expression should be optimized to a NOR gate by the synthesis tool
    end
    
endmodule