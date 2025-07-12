module TopModule(
    input [1:0] A,
    input [1:0] B,
    output reg z
);

always @(*) begin
    case (A)
        2'b00: z = (B == 2'b00)? 1'b1 : 1'b0;
        2'b01: z = (B == 2'b01)? 1'b1 : 1'b0;
        2'b10: z = (B == 2'b10)? 1'b1 : 1'b0;
        2'b11: z = (B == 2'b11)? 1'b1 : 1'b0;
        default: z = 1'b0;
    endcase
end

endmodule