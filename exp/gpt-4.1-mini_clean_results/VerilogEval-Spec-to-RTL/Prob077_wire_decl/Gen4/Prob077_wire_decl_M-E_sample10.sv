module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out,
    output reg out_n
);

reg and1_out, and2_out;

always @(*) begin
    // First layer: two AND gates
    and1_out = a & b;
    and2_out = c & d;
    // Second layer: OR gate
    out = and1_out | and2_out;
    // Inverted output
    out_n = ~out;
end

endmodule