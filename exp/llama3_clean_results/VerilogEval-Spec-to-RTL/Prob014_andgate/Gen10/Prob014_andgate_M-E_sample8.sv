module TopModule(
    input  a,
    input  b,
    output out
);

reg [1:0] lut[3:0] = '{4'b0001, 4'b0010, 4'b0100, 4'b1000};
reg [1:0] index;

always @(*) begin
    case({a, b})
        2'b00: index = 3'b000;
        2'b01: index = 3'b001;
        2'b10: index = 3'b010;
        2'b11: index = 3'b011;
    endcase
    out = lut[index][0];
end

endmodule