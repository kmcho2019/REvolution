module TopModule(
    input  [254:0] in,
    output reg [7:0] out // Declare out as reg for internal assignments
);

    reg [7:0] lut [255:0]; // LUT for counting '1's in 8-bit blocks

    // Initialize the LUT
    initial begin
        for (int i = 0; i < 256; i++) begin
            lut[i] = 8'd0;
            for (int j = 0; j < 8; j++) begin
                if (i & (1 << j))
                    lut[i] = lut[i] + 1;
            end
        end
    end

    // Count the '1's in each block and sum up the counts
    always @(*) begin
        out = 8'd0;
        for (int i = 0; i < 252; i = i + 8) begin // Loop through 31 full blocks of 8 bits
            out = out + lut[in[i +: 8]]; // Use the LUT to count '1's in the current block
        end
        // Handle the last 7 bits (which form an incomplete block)
        for (int j = 0; j < 7; j++) begin
            if (in[254 - j])
                out = out + 1;
        end
    end

endmodule