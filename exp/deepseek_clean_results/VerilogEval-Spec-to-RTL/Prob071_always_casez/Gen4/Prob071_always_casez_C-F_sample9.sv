module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    if (in == 8'b0) begin
        pos = 3'b0;  // Early exit for all-zero case
    end else begin
        casez (in[3:0])
            4'b???1: pos = 3'b000;  // Bit 0
            4'b??10: pos = 3'b001;  // Bit 1
            4'b?100: pos = 3'b010;  // Bit 2
            4'b1000: pos = 3'b011;  // Bit 3
            default: begin  // Check upper nibble
                casez (in[7:4])
                    4'b???1: pos = 3'b100;  // Bit 4
                    4'b??10: pos = 3'b101;  // Bit 5
                    4'b?100: pos = 3'b110;  // Bit 6
                    4'b1000: pos = 3'b111;  // Bit 7
                    default: pos = 3'b000;   // Shouldn't happen due to first check
                endcase
            end
        endcase
    end
end

endmodule