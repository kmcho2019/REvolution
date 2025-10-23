module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

    always @(*) begin
        // Combinational logic: q is high if b or c is high
        q = b | c;
    end

endmodule