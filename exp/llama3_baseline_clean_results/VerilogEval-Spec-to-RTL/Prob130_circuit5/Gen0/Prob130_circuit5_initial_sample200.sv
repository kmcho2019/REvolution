module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

always @(a, b, c, d, e) begin
    case (c[1:0])  // Only considering the lower 2 bits of c as per the waveform
        2'b00: q = b;  // c = 0
        2'b01: q = e;  // c = 1
        2'b10: q = a;  // c = 2
        2'b11: q = d;  // c = 3
        default: q = 4'b1111;  // Assigning all ones for c values > 3
    endcase
end

endmodule