module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);
    always @(*) begin
        q = ((a | b) && (c | d)) ? 1'b1 : 1'b0;
    end
endmodule