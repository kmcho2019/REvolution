module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    // Define the lookup table
    reg [2:0] lut [255:0];

    // Initialize the lookup table
    initial begin
        for (int i = 0; i < 256; i++) begin
            lut[i] = 3'd0;  // Default value
            for (int j = 0; j < 8; j++) begin
                if ((i >> j) & 1'b1) begin
                    lut[i] = j;  // Store the position of the first '1' bit
                    break;
                end
            end
        end
    end

    // Use the lookup table to determine the output
    assign pos = lut[in];

endmodule