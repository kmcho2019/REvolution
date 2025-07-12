module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(*) begin
    casez (in)
        4'b0001: pos = 2'b01;
        4'b001?: pos = 2'b10;
        4'b01??: pos = 2'b11;
        4'b1??? : pos = 2'b00; // This will actually be the first case that matches if the most significant bit is 1
        default: pos = 2'b00; // Output 0 if no '1' is found
    endcase
end

endmodule