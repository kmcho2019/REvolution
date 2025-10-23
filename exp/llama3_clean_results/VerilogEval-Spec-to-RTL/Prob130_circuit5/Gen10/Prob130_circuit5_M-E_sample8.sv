module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

reg [3:0] q_reg;

always @(*) begin
    reg [3:0] sel;
    case (c[1:0])
        2'b00: sel = 4'b0001;
        2'b01: sel = 4'b0010;
        2'b10: sel = 4'b0100;
        2'b11: sel = 4'b1000;
        default: sel = 4'b0000;
    endcase

    q_reg = (sel[0] ? b : 4'b0000) | (sel[1] ? e : 4'b0000) | (sel[2] ? a : 4'b0000) | (sel[3] ? d : 4'b0000);

    if (c[3:2] != 2'b00) begin
        q_reg = 4'b1111;
    end
end

assign q = q_reg;

endmodule