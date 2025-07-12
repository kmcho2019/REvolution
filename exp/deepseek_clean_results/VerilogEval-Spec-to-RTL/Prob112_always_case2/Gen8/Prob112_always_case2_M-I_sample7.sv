module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    if (in == 4'b0000) begin
        pos = 2'b00;  // Explicit zero case handling first
    end else begin
        casez (in)
            4'b???1: pos = 2'b00;  // Bit 0 is 1
            4'b??10: pos = 2'b01;  // Bit 1 is 1
            4'b?100: pos = 2'b10;  // Bit 2 is 1
            4'b1000: pos = 2'b11;  // Bit 3 is 1
        endcase
    end
end

endmodule