module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

    // Implementing the Karnaugh map logic directly using basic gates
    always @(*) begin
        out = (a & b & ~c & ~d) | (~a & ~b & c & ~d) | (~a & b & ~c & d) | (a & ~b & c & d) | (~a & b & c & ~d) | (a & ~b & ~c & d);
    end

endmodule