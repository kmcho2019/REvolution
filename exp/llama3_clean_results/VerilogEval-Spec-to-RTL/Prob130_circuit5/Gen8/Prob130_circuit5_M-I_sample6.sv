module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

// Directly select the output based on the value of c
always @(*) begin
    case(c[1:0])
        2'b00: q = b;
        2'b01: q = e;
        2'b10: q = a;
        2'b11: q = d;
        default: q = 4'b1111;  // 'f' is represented as 4'b1111
    endcase
end

endmodule