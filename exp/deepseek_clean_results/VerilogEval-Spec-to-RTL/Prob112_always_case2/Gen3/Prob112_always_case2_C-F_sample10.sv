module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    if (in == 4'b0000) begin
        pos = 2'b00;  // Explicit zero case first for power optimization
    end
    else begin
        casez (in)
            4'b1???: pos = 2'b11;  // Bit 3 has highest priority
            4'b01??: pos = 2'b10;  // Bit 2 next
            4'b001?: pos = 2'b01;  // Bit 1 next
            4'b0001: pos = 2'b00;  // Bit 0 last
            default: pos = 2'b00;   // Shouldn't occur due to if condition
        endcase
    end
end

endmodule