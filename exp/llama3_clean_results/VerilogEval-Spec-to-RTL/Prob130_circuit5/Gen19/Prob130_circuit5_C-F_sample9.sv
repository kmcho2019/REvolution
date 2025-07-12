module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

always @(*) begin
    case (c[1:0])
        2'b00: q = (c[3:2] == 2'b00) ? b : 4'b1111;
        2'b01: q = (c[3:2] == 2'b00) ? e : 4'b1111;
        2'b10: q = (c[3:2] == 2'b00) ? a : 4'b1111;
        2'b11: q = (c[3:2] == 2'b00) ? d : 4'b1111;
    endcase
end

endmodule