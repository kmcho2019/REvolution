module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    casez (in)
        4'b1000: pos = 2'b11; // position 4
        4'b100x: pos = 2'b11; // position 4
        4'b0100: pos = 2'b10; // position 3
        4'b010x: pos = 2'b10; // position 3
        4'b0010: pos = 2'b01; // position 2
        4'b001x: pos = 2'b01; // position 2
        4'b0001: pos = 2'b00; // position 1
        default: pos = 2'b00; // no '1' bits
    endcase
end

endmodule