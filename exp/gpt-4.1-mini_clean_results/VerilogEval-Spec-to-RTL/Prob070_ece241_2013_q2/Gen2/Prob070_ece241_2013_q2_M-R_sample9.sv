module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

always @(*) begin
    // Minimal SOP: out_sop = (b & c & d) | (~a & ~b & c & ~d)
    out_sop = (b & c & d) | (~a & ~b & c & ~d);
end

always @(*) begin
    // Minimal POS: out_pos = (a | b | d) & (a | c | d) & (~a | ~b | c | ~d)
    out_pos = (a | b | d) & (a | c | d) & (~a | ~b | c | ~d);
end

endmodule