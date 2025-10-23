module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

reg [1:0] lut_addr;
reg [0:0] lut_out;

always @(*) begin
    lut_addr = {x3, x2};
    case(lut_addr)
        2'b00: lut_out = x1? 1'b0 : 1'b0;
        2'b01: lut_out = x1? 1'b1 : 1'b1;
        2'b10: lut_out = x1? 1'b1 : 1'b0;
        2'b11: lut_out = x1? 1'b1 : 1'b0;
    endcase
    f = lut_out;
end

endmodule