module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    case (1)
        in[3]: pos = 2'b11; // MSB is '1'
        in[2]: pos = 2'b10; // Second MSB is '1'
        in[1]: pos = 2'b01; // Second LSB is '1'
        in[0]: pos = 2'b10; // LSB is '1', position should be 4, but since we only have 2 bits to represent the position, we use 2'b10 to indicate it
        default: pos = 2'b00; // No '1' bits found
    endcase
end

endmodule