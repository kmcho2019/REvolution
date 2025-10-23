module TopModule(
    input a,
    input b,
    input c,
    input d,
    output reg q
);
    wire ab_xor;
    wire cd_xor;

    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;

    always @(*) begin
        if (ab_xor == cd_xor)
            q = 1'b1;
        else
            q = 1'b0;
    end
endmodule