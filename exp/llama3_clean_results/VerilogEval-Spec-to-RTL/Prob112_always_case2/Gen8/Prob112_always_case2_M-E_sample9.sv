module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    case (in)
        4'b1000: pos = 2'b11; // MSB (4th position) -> 3
        4'b1000: pos = 2'b11; // MSB (4th position) -> 3
        4'b0100: pos = 2'b10; // Second MSB (3rd position) -> 2
        4'b0010: pos = 2'b01; // Second LSB (2nd position) -> 1
        4'b0001: pos = 2'b00; // LSB (1st position) -> 0
        default: pos = 2'b00; // No '1' bits found
    endcase
end

endmodule