module TopModule(
    input  a,
    input  b,
    output reg out
);
    // Combinational always block to compute XNOR using XOR and NOT
    always @(*) begin
        out <= ~(a ^ b);
    end
endmodule