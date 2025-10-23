module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

always_comb begin
    case (c[1:0])
        2'b00: q = (c[3:2] != 2'b00) ? 4'b1111 : (c == 4'd0) ? b : 4'b1111;
        2'b01: q = (c[3:2] != 2'b00) ? 4'b1111 : (c == 4'd1) ? e : 4'b1111;
        2'b10: q = (c[3:2] != 2'b00) ? 4'b1111 : (c == 4'd2) ? a : 4'b1111;
        2'b11: q = (c[3:2] != 2'b00) ? 4'b1111 : (c == 4'd3) ? d : 4'b1111;
    endcase
end

endmodule