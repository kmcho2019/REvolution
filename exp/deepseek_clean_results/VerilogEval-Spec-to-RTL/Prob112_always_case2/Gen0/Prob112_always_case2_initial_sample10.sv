module TopModule (
    input [3:0] in,
    output [1:0] pos
);

    always @(*) begin
        casez (in)
            4'b1???: pos = 2'b11; // First '1' at bit 3
            4'b01??: pos = 2'b10;  // First '1' at bit 2
            4'b001?: pos = 2'b01;  // First '1' at bit 1
            4'b0001: pos = 2'b00; // First '1' at bit 0
            default: pos = 2'b00;  // No '1's found
        endcase
    end

endmodule