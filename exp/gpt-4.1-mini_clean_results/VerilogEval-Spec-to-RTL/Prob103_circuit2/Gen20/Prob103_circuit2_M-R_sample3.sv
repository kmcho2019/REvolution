module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);
    always @(*) begin
        q = ~ (a ^ b ^ c ^ d);  // Calculate even parity inside an always block
    end
endmodule