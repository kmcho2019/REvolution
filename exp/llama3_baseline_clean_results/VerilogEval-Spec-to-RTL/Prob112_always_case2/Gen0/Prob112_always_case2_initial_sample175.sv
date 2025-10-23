module TopModule(
    input [3:0] in,
    output [1:0] pos
);

    always @(*) begin
        if (in[3]) begin
            pos = 2'b11; // Position of MSB (bit 3) is 3, so output 11
        end else if (in[2]) begin
            pos = 2'b10; // Position of bit 2 is 2, so output 10
        end else if (in[1]) begin
            pos = 2'b01; // Position of bit 1 is 1, so output 01
        end else if (in[0]) begin
            pos = 2'b00; // Position of LSB (bit 0) is 0, so output 00
        end else begin
            pos = 2'b00; // If none of the bits are 1, output 00
        end
    end

endmodule