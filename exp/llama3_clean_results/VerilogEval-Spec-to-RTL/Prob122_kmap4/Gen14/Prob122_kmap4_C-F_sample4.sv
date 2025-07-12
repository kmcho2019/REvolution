module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

    always @(*) begin
        out = (a ^ b) ^ (c ^ d); // Implementing the Karnaugh map logic using XOR operations within a combinational always block
    end

endmodule