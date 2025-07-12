module TopModule(
    input [3:0] in,
    output [1:0] pos
);

    always @(*) begin
        casez(in)
            4'b1000: pos = 2'b11;
            4'b100:  pos = 2'b10;
            4'b10:   pos = 2'b01;
            4'b1:    pos = 2'b00;
            default: pos = 2'b00;
        endcase
    end

endmodule