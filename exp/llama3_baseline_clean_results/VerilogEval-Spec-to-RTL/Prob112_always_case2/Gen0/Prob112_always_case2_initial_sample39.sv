module TopModule(in, pos);
    input [3:0] in;
    output [1:0] pos;

    always @(in) begin
        case (1'b1)
            in[3]: pos = 2'b11; // 4th bit is set
            in[2]: pos = 2'b10; // 3rd bit is set
            in[1]: pos = 2'b01; // 2nd bit is set
            in[0]: pos = 2'b00; // 1st bit is set
            default: pos = 2'b00; // no bits are set
        endcase
    end
endmodule