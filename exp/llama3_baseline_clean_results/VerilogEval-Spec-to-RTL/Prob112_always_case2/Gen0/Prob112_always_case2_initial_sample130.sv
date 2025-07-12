module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

    always @(*) begin
        case (1'b1)
            in[3]: pos = 2'b11; // Position 3
            in[2]: pos = 2'b10; // Position 2
            in[1]: pos = 2'b01; // Position 1
            in[0]: pos = 2'b00; // Position 0
            default: pos = 2'b00; // No '1' bit found, output 0
        endcase
    end

endmodule