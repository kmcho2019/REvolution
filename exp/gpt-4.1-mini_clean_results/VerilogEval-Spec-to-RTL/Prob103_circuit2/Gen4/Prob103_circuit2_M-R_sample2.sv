module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);
    // Combinational logic computing even parity via procedural block
    always @(*) begin
        // q is 1 if the number of 1's in inputs is even
        q = ~ (a ^ b ^ c ^ d);
    end
endmodule