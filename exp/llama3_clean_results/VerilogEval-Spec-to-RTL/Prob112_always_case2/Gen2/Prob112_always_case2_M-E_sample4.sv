module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(*) begin
    case (in)
        4'b1000: pos = 2'b00; // MSB is '1'
        4'b0100: pos = 2'b01;
        4'b0010: pos = 2'b10;
        4'b0001: pos = 2'b11;
        default: pos = 2'b00; // No '1' bits found
    endcase
end

endmodule