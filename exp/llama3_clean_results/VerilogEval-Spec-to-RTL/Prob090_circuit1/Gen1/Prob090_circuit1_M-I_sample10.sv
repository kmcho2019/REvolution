module TopModule(
    input  a,
    input  b,
    output reg q // Explicitly declaring q as a reg for clarity
);
    
    always @(*) begin
        q = a & b; // Using a continuous assignment within an always block for clarity
    end

endmodule