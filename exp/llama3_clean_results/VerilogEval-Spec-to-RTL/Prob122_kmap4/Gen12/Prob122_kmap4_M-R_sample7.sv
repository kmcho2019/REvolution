module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

    always @(*) begin
        // Implementing the Karnaugh map logic using XOR operations within an always block
        out = (a ^ b) ^ (c ^ d);
    end

endmodule