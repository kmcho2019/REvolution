module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);
    wire parity;
    assign parity = a ^ b ^ c ^ d;

    always @(*) begin
        q = ~parity;
    end
endmodule