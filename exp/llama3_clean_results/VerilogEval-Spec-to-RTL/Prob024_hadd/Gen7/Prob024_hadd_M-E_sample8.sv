module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);

reg [1:0] lut_sum = 2'b01; // sum for a=0, b=0: 0; a=0, b=1: 1; a=1, b=0: 1; a=1, b=1: 0
reg [1:0] lut_cout = 2'b00; // carry-out for a=0, b=0: 0; a=0, b=1: 0; a=1, b=0: 0; a=1, b=1: 1

always @(*) begin
    case({a, b})
        2'b00: begin sum = lut_sum[0]; cout = lut_cout[0]; end
        2'b01: begin sum = lut_sum[1]; cout = lut_cout[1]; end
        2'b10: begin sum = lut_sum[1]; cout = lut_cout[1]; end
        2'b11: begin sum = lut_sum[0]; cout = lut_cout[1]; end
    endcase
end

endmodule