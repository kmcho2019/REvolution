module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(*) begin
    casez (in)
        4'b1000: pos = 2'b11; // bit 3 is high
        4'b0100: pos = 2'b10; // bit 2 is high
        4'b0010: pos = 2'b01; // bit 1 is high
        4'b0001: pos = 2'b00; // bit 0 is high
        default: pos = 2'b00; // no bit is high
    endcase
end

endmodule