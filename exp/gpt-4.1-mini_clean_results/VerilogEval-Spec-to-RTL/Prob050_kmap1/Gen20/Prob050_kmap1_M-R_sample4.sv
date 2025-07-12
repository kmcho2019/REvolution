module TopModule (
    input  a,
    input  b,
    input  c,
    output reg out
);
    // Logical function derived from K-map:
    // out = a + b + c
    always @(*) begin
        out = a | b | c;
    end
endmodule