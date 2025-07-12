module TopModule (
    input  [3:0] in,
    output [1:0] pos
);

    always @(*) begin
        casez (in)
            4'b1000: pos = 2'b00;
            4'b1001, 4'b1010, 4'b1011, 4'b1100, 4'b1101, 4'b1110, 4'b1111: pos = 2'b00;
            4'b0100: pos = 2'b01;
            4'b0101, 4'b0110, 4'b0111: pos = 2'b01;
            4'b0010: pos = 2'b10;
            4'b0011: pos = 2'b10;
            4'b0001: pos = 2'b11;
            default: pos = 2'b00;
        endcase
    end

endmodule