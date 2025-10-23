module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

    // Implementing the Karnaugh map logic using XOR operations within a combinational always block
    // This approach is efficient for area and power, and the use of a combinational always block allows for flexibility
    always @(*) begin
        out = (a ^ b) ^ (c ^ d);
    end

endmodule