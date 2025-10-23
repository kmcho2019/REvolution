module TopModule(
    input [3:0] in,
    output [1:0] pos
);

    always @(*) begin
        case (1'b1)
            in[3]: pos = 2'b11; // position 3
            in[2]: pos = 2'b10; // position 2
            in[1]: pos = 2'b01; // position 1
            in[0]: pos = 2'b00; // position 0
            default: pos = 2'b00; // no '1' found, output 0
        endcase
    end

endmodule