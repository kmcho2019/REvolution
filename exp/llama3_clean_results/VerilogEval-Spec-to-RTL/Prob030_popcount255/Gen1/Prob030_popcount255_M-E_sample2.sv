module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    reg [7:0] count;
    reg [7:0] lut [255:0];

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
        count = 8'd0;
        for (int i = 0; i < 255; i = i + 8) begin
            reg [7:0] block_count;
            reg [7:0] block_in;
            block_in = in[i +: 8];
            block_count = lut[block_in];
            count = count + block_count;
        end
        out = count;
    end

endmodule