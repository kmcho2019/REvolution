module TopModule(
    input [255:0] in,
    output [7:0] out
);

    reg [7:0] out_reg;

    always @(*) begin
        reg [7:0] byte_counts [31:0];
        reg [7:0] chunk_sum;

        // Initialize chunk_sum to 0
        chunk_sum = 0;

        // Count the number of '1's in each byte
        for (int i = 0; i < 32; i++) begin
            reg [7:0] byte;
            byte = in[(i*8)+:8];
            byte_counts[i] = byte[0] + byte[1] + byte[2] + byte[3] + byte[4] + byte[5] + byte[6] + byte[7];
        end

        // Sum up the byte counts
        for (int i = 0; i < 32; i++) begin
            chunk_sum = chunk_sum + byte_counts[i];
        end

        out_reg = chunk_sum;
    end

    assign out = out_reg;

endmodule