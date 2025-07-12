module TopModule(
    input  [3:0] in,  // 4-bit input
    output [1:0] pos  // 2-bit output representing the position
);

    always @(in) begin
        if (in[3] == 1'b1) begin
            pos = 2'b11;  // MSB position (3)
        end else if (in[2] == 1'b1) begin
            pos = 2'b10;  // second MSB position (2)
        end else if (in[1] == 1'b1) begin
            pos = 2'b01;  // second LSB position (1)
        end else if (in[0] == 1'b1) begin
            pos = 2'b00;  // LSB position (0)
        end else begin
            pos = 2'b00;  // if none of the bits are high, output 0
        end
    end

endmodule