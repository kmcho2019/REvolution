module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

    wire ab_xor;
    wire cd_xor;

    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;

    always @(*) begin
        q <= ~(ab_xor ^ cd_xor);
    end

endmodule