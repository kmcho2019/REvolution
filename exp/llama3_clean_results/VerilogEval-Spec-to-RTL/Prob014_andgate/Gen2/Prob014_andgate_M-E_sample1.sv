module TopModule(
    input  a,
    input  b,
    output out
);

reg [1:0] lut_address;
reg out;

always @(*) begin
    lut_address = {a, b};
    case(lut_address)
        2'b00: out = 1'b0;
        2'b01: out = 1'b0;
        2'b10: out = 1'b0;
        2'b11: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule