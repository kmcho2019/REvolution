module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    case (in)
        4'b1000: pos = 2'b11; // Position 4
        4'b100:  pos = 2'b10; // Position 3 (but in binary this is the third position)
        4'b10:   pos = 2'b01; // Position 2
        4'b1:    pos = 2'b00; // Position 1
        default: pos = 2'b00; // Default to 0 if no '1' bits are found
    endcase
end

endmodule