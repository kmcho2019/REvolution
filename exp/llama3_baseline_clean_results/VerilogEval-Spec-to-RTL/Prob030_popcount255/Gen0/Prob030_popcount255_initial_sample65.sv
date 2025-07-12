module TopModule(
    input [254:0] in,  // 255-bit input vector
    output [7:0] out   // 8-bit output vector
);

    // Initialize the count to 0
    reg [7:0] count;

    // Initialize 8-bit chunk counters
    reg [7:0] chunk_count [31:0];

    always @(*) begin
        // Initialize count to 0
        count = 8'b0;

        // Iterate over each 8-bit chunk of the input vector
        for (int i = 0; i < 32; i++) begin
            // Extract the current 8-bit chunk
            reg [7:0] chunk;
            chunk = in[i*8 +: 8];

            // Count the number of '1's in the current chunk
            chunk_count[i] = 8'b0;
            for (int j = 0; j < 8; j++) begin
                chunk_count[i] = chunk_count[i] + chunk[j];
            end

            // Add the count from the current chunk to the total count
            count = count + chunk_count[i];
        end

        // Assign the total count to the output
        out = count;
    end

endmodule