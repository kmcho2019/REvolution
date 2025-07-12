module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    // Reverse byte order by direct slicing and concatenation:
    // Output bytes are arranged from the least significant byte of 'in' to the most significant byte of 'in' in reverse order.
    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};

endmodule