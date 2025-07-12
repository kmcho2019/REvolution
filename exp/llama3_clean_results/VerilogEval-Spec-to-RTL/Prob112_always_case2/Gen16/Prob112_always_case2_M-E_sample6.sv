module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    case(in)
        4'b1000: pos = 2'b11; // MSB is '1', position 3
        4'b0100: pos = 2'b10; // Second MSB is '1', position 2
        4'b0010: pos = 2'b01; // Second LSB is '1', position 1
        4'b0001: pos = 2'b00; // LSB is '1', position 0
        default: pos = 2'b00; // No '1' bits, output 0
    endcase
end

endmodule