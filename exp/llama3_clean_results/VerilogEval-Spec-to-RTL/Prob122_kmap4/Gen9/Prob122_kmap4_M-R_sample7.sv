module TopModule(
    input a,
    input b,
    input c,
    input d,
    output reg out
);

always @(*) begin
    reg ab_xor;
    reg cd_xor;
    
    ab_xor = a ^ b;
    cd_xor = c ^ d;
    
    out = ab_xor ^ cd_xor;
end

endmodule