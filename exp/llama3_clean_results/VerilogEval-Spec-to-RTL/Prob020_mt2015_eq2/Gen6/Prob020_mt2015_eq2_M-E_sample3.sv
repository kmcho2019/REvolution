module TopModule(
    input [1:0] A,
    input [1:0] B,
    output reg z
);

always @(*) begin
    case ({A, B})
        4'b0000, 4'b0101, 4'b1010, 4'b1111: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule