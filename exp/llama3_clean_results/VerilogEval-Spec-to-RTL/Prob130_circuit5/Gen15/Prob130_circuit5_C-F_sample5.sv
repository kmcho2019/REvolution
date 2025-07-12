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
        2'b00: q = (c == 4'd0) ? b : 4'd15;
        2'b01: q = (c == 4'd1) ? e : 4'd15;
        2'b10: q = (c == 4'd2) ? a : 4'd15;
        2'b11: q = (c == 4'd3) ? d : 4'd15;
        default: q = 4'd15;
    endcase

    if (c[3:2] != 2'b00) begin
        q = 4'd15;
    end
end

endmodule