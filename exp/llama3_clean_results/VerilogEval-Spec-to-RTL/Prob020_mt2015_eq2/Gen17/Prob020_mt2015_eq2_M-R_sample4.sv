module TopModule(
    input [1:0] A,
    input [1:0] B,
    output reg z
);
always @(*) begin
    case ({A, B})
        4'b0000, 4'b0011, 4'b1100, 4'b1111: z = 1'b1;
        default: z = 1'b0;
    endcase
end
endmodule