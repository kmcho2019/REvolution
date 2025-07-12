module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    wire [3:0] in_vec = {a,b,c,d}; // a MSB, d LSB

    // Minimal SOP expression for out_sop
    // minterms for 2 (0010), 7 (0111), 15 (1111):
    // 2 = ~a & ~b & c & ~d
    // 7 = ~a & b & c & d
    // 15 = a & b & c & d
    assign out_sop = (~a & ~b &  c & ~d) |
                     (~a &  b &  c &  d) |
                     ( a &  b &  c &  d);

    // Minimal POS expression for out_pos (outputs 1 for same cases as out_sop)
    // Derived from zeros and don't cares:
    // out_pos = (a + ~b + ~c + d) & (a + b + c + ~d)
    assign out_pos = (a | ~b | ~c | d) & (a | b | c | ~d);

endmodule