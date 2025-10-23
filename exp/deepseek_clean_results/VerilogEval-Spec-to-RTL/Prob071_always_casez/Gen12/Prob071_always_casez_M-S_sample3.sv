module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    casez (in)
        8'b???????1: pos = 3'b000;
        8'b??????10: pos = 3'b001;
        8'b?????100: pos = 3'b010;
        8'b????1000: pos = 3'b011;
        8'b???10000: pos = 3'b100;
        8'b??100000: pos = 3'b101;
        8'b?1000000: pos = 3'b110;
        8'b10000000: pos = 3'b111;
        default:    pos = 3'b000;
    endcase
end

endmodule