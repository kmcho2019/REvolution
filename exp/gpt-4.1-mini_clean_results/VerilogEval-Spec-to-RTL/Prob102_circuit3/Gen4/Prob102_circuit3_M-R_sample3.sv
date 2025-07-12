module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);
    always @(*) begin
        q = (a & c) | (a & d) | (b & c) | (b & d);
    end
endmodule