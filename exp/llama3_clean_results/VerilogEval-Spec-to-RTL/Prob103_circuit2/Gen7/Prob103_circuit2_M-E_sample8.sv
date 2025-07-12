module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic q
);
    // Using K-map simplification, we derive the following expression:
    // q = (~a & ~b & ~c) | (~a & ~b & d) | (~a & b & ~c & ~d) | (a & ~b & ~c & ~d) | (a & ~b & c & ~d) | (a & b & ~c & ~d)
    assign q = (~a & ~b & ~c) | (~a & ~b & d) | (~a & b & ~c & ~d) | (a & ~b & ~c & ~d) | (a & ~b & c & ~d) | (a & b & ~c & ~d);
endmodule