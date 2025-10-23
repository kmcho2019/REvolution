module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

    always @(in) begin
        case (1'b1)
            in[3]: pos = 2'b11; // MSB is 1, output position 3
            in[2]: pos = 2'b10; // second MSB is 1, output position 2
            in[1]: pos = 2'b01; // second LSB is 1, output position 1
            in[0]: pos = 2'b00; // LSB is 1, output position 0
            default: pos = 2'b00; // none of the bits are 1, output 0
        endcase
    end

endmodule