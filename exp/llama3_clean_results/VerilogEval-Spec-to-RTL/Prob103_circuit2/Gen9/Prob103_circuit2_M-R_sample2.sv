module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);
    
    // Define a combinational logic block within an always block
    always @(*) begin
        // Compute the output q as the inverse of the XOR of a, b, c, and d
        q = ~(a ^ b ^ c ^ d);
    end
    
endmodule