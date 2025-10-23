module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(*) begin
    casez (in)
        4'b1000: pos = 2'b11; // position 3
        4'b0100: pos = 2'b10; // position 2
        4'b0010: pos = 2'b01; // position 1
        4'b0001: pos = 2'b00; // position 0
        default: pos = 2'b00; // default to 0 if no '1' bit found
    endcase
end

endmodule