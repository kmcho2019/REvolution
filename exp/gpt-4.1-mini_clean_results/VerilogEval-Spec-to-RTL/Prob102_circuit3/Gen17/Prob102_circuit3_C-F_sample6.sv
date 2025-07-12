module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);
    always_comb begin
        q = (a | b) & (c | d);
    end
endmodule