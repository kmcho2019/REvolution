module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(*) begin
    if (in[3] == 1'b1) begin
        pos = 2'b11; // most significant bit
    end else if (in[2] == 1'b1) begin
        pos = 2'b10;
    end else if (in[1] == 1'b1) begin
        pos = 2'b01;
    end else if (in[0] == 1'b1) begin
        pos = 2'b00; // least significant bit
    end else begin
        pos = 2'b00; // none of the bits are high
    end
end

endmodule