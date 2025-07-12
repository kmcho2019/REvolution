module TopModule(
    input [254:0] in,
    output [7:0] out
);

    reg [7:0] count;

    // Divide the 255-bit input vector into 5 segments of 51 bits each
    reg [7:0] segment_count[4:0];

    always @(in) begin
        // Initialize segment counts
        for (int i = 0; i <= 4; i++) begin
            segment_count[i] = 8'b0;
        end

        // Count '1's in each segment
        for (int i = 0; i < 5; i++) begin
            for (int j = 0; j < 51; j++) begin
                segment_count[i] = segment_count[i] + in[(i * 51) + j];
            end
        end

        // Accumulate counts from all segments
        count = 8'b0;
        for (int i = 0; i <= 4; i++) begin
            count = count + segment_count[i];
        end
    end

    assign out = count;

endmodule