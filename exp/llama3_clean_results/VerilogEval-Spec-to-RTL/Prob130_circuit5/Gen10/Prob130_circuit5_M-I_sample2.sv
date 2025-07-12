module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

always @(*) begin
    case (c[1:0])
        2'b00: q = b;
        2'b01: q = e;
        2'b10: q = a;
        2'b11: q = d;
    endcase

    if (c[3] || c[2]) begin
        q = 4'b1111;
    end
end

endmodule