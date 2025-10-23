module TopModule (
    input [2:0] in,
    output reg [1:0] out
);

always @(*) begin
    case (in)
        3'b000: out = 2'b00;  // 0 ones
        3'b001,
        3'b010,
        3'b100: out = 2'b01;  // 1 one
        3'b011,
        3'b101,
        3'b110: out = 2'b10;  // 2 ones
        3'b111: out = 2'b11;  // 3 ones
    endcase
end

endmodule