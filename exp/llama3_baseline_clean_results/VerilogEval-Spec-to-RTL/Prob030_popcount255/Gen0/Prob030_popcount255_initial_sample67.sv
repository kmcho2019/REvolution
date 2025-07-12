module TopModule(
    input [254:0] in,
    output reg [7:0] out
);

    reg [3:0] count [15:0]; // 16 chunks of 4-bit counters

    always @(*) begin
        for (int i = 0; i < 15; i++) begin
            // Count the number of '1's in each 16-bit chunk
            count[i] = 4'b0;
            for (int j = 0; j < 16; j++) begin
                if (in[(i * 16) + j]) begin
                    count[i] = count[i] + 1;
                end
            end
        end

        // Count the number of '1's in the last 15-bit chunk
        count[15] = 4'b0;
        for (int j = 0; j < 15; j++) begin
            if (in[(15 * 16) + j]) begin
                count[15] = count[15] + 1;
            end
        end

        // Add up the counts from each chunk
        out = 8'b0;
        for (int i = 0; i < 16; i++) begin
            out = out + {4'b0, count[i]};
        end
    end

endmodule