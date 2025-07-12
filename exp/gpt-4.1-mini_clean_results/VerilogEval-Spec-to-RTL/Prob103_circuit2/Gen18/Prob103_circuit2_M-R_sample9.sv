module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

    wire abc_xor;
    
    always @(*) begin
        // Compute XOR of a, b, c
        // q is the inverted XOR of abc_xor and d, equivalent to 4-input XNOR
        q = ~ (abc_xor ^ d);
    end

    assign abc_xor = a ^ b ^ c;

endmodule