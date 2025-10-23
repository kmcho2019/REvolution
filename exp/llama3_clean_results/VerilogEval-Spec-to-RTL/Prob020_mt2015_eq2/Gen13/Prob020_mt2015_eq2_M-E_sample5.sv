module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);

always_comb begin
    case ({A, B})
        4'b0000: z = 1'b1;
        4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b0110, 4'b0111, 4'b1000, 4'b1001, 4'b1010, 4'b1011, 4'b1100, 4'b1101, 4'b1110: z = 1'b0;
        4'b1111: z = 1'b1;
        default: z = 1'bx;
    endcase
end

endmodule