module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

reg [1:0] addr;
reg [0:0] data;

always @(*) begin
    case ({x3, x2, x1})
        3'b000: data = 1'b0;
        3'b001: data = 1'b0;
        3'b010: data = 1'b1;
        3'b011: data = 1'b1;
        3'b100: data = 1'b0;
        3'b101: data = 1'b1;
        3'b110: data = 1'b0;
        3'b111: data = 1'b1;
    endcase
end

assign f = data;

endmodule