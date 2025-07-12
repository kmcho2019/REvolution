module TopModule(
    input  [3:0] in,
    output reg [1:0] pos // Declare pos as a reg type
);

always @(*) begin
    case (in)
        4'b1000: pos = 2'b00; // MSB is '1'
        4'b1001, 4'b1010, 4'b1011, 4'b1100, 4'b1101, 4'b1110, 4'b1111: pos = 2'b00; // MSB is '1'
        4'b0100: pos = 2'b01;
        4'b0101, 4'b0110, 4'b0111: pos = 2'b01; // Second bit is the first '1'
        4'b0010: pos = 2'b10;
        4'b0011: pos = 2'b10; // Third bit is the first '1'
        4'b0001: pos = 2'b11; // Fourth bit is the first '1'
        default: pos = 2'b00; // No '1' bits found, or all bits are '0'
    endcase
end

endmodule