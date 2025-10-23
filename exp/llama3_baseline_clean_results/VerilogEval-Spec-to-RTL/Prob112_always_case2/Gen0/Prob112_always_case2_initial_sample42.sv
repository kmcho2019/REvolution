module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

    always @(in) begin
        casez(in)
            4'b1000: pos = 2'b10;
            4'b100x: pos = 2'b10;
            4'b0100: pos = 2'b01;
            4'b010x: pos = 2'b01;
            4'b0010: pos = 2'b00;
            4'b001x: pos = 2'b00;
            4'b0001: pos = 2'b11;
            4'b000x: pos = 2'b00;
            default: pos = 2'b00;
        endcase
    end

endmodule