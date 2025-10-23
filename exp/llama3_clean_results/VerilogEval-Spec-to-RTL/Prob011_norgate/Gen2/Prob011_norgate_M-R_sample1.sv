module TopModule(
    input  a,
    input  b,
    output reg out
);
    
    always @(*) begin
        // Using an always block with combinational logic sensitivity
        out = ~(a | b);
    end
    
endmodule