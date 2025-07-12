module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    wire [31:0] shifted = {in, 24'b0};  // Left shift by 24 bits
    assign out = shifted >>> 24;        // Arithmetic right shift propagates sign bit
endmodule