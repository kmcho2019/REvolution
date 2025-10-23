module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

    always @(*)
    begin
        if (in[3] == 1'b1) pos = 2'b11; // First bit (most significant)
        else if (in[2] == 1'b1) pos = 2'b10; // Second bit
        else if (in[1] == 1'b1) pos = 2'b01; // Third bit
        else if (in[0] == 1'b1) pos = 2'b00; // Least significant bit
        else pos = 2'b00; // If none of the bits are high
    end

endmodule