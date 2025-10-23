module TopModule(
    input  [3:0] in,
    output logic [1:0] pos
);

always_comb begin
    casez (in)
        4'b1000: pos = 2'b11; // MSB is set
        4'b1001, 4'b1010, 4'b1011, 4'b1100, 4'b1101, 4'b1110, 4'b1111: pos = 2'b11; // Any other case with MSB set
        4'b0100: pos = 2'b10; // Second bit from MSB is set
        4'b0101, 4'b0110, 4'b0111: pos = 2'b10; // Any other case with second bit from MSB set
        4'b0010: pos = 2'b01; // Third bit from MSB is set
        4'b0011: pos = 2'b01; // Any other case with third bit from MSB set
        4'b0001: pos = 2'b00; // LSB is set
        default: pos = 2'b00; // No bit is set
    endcase
end

endmodule