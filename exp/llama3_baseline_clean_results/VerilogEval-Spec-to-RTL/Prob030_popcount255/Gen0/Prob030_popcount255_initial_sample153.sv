module TopModule(
    input [255:0] in,
    output [7:0] out
);

    // Initialize count variables
    reg [7:0] byte_counts [31:0];  // Count '1's in each byte
    reg [7:0] group_counts [7:0];  // Count '1's in each group of 32 bytes
    reg [7:0] total_count;        // Total population count

    // Count '1's in each byte
    always @(*) begin
        for (int i = 0; i < 32; i++) begin
            byte_counts[i] = 8'b0;
            for (int j = 0; j < 8; j++) begin
                byte_counts[i] = byte_counts[i] + in[(i*8)+j];
            end
        end
    end

    // Count '1's in each group of 32 bytes
    always @(*) begin
        for (int i = 0; i < 8; i++) begin
            group_counts[i] = 8'b0;
            for (int j = 0; j < 32; j++) begin
                group_counts[i] = group_counts[i] + byte_counts[i*32+j];
            end
        end
    end

    // Calculate total population count
    always @(*) begin
        total_count = 8'b0;
        for (int i = 0; i < 8; i++) begin
            total_count = total_count + group_counts[i];
        end
        out = total_count;
    end

endmodule