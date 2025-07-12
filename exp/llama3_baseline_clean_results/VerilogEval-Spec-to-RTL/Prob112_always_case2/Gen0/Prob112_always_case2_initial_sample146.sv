module TopModule(
    input [3:0] in,
    output [1:0] pos
);

always @(*) begin
    casez (in)
        4'b1000: pos = 2'b11; // position of first 1 bit is 3
        4'b0100: pos = 2'b10; // position of first 1 bit is 2
        4'b0010: pos = 2'b01; // position of first 1 bit is 1
        4'b0001: pos = 2'b00; // position of first 1 bit is 0
        default: pos = 2'b00; // if none of the input bits are high, output 0
    endcase
end

endmodule