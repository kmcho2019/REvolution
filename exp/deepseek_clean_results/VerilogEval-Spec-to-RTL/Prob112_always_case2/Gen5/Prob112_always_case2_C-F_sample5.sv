module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    if (in == 4'b0000) begin
        pos = 2'b00;  // Early exit for all-zero case
    end
    else begin
        casez (in)
            4'b1???: pos = 2'b11;  // Bit 3 has highest priority
            4'b01??: pos = 2'b10;  // Bit 2
            4'b001?: pos = 2'b01;  // Bit 1
            4'b0001: pos = 2'b00;  // Bit 0
            default: pos = 2'b00;   // Should never reach here
        endcase
    end
end

endmodule