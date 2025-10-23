module TopModule (
    input  a,
    input  b,
    output reg out_and,
    output reg out_or,
    output reg out_xor,
    output reg out_nand,
    output reg out_nor,
    output reg out_xnor,
    output reg out_anotb
);

    always @(*) begin
        // Basic operations
        out_and  = a & b;
        out_or   = a | b;
        out_xor  = a ^ b;
        
        // Negated operations
        out_nand = ~(a & b);
        out_nor  = ~(a | b);
        out_xnor = ~(a ^ b);
        
        // Special case operation
        out_anotb = a & ~b;
    end

endmodule