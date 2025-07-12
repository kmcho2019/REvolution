module TopModule(
    input [3:0] in,
    output [1:0] pos
);

always @(*) begin
    case (1'b1)
        in[3]: pos = 2'b11; // 3
        in[2]: pos = 2'b10; // 2
        in[1]: pos = 2'b01; // 1
        in[0]: pos = 2'b00; // 0
        default: pos = 2'b00; // none of the bits are high
    endcase
end

endmodule