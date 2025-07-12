module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Count the number of '1's in each byte
    reg [7:0] byte_counts [31:0];
    integer i;
    always @(*) begin
        for (i = 0; i < 32; i++) begin
            byte_counts[i] = 8'b0;
            for (int j = 0; j < 8; j++) begin
                if (in[(i*8) + j]) begin
                    byte_counts[i] = byte_counts[i] + 1'b1;
                end
            end
        end
    end

    // Sum up the counts of all the bytes
    reg [7:0] count;
    always @(*) begin
        count = 8'b0;
        for (i = 0; i < 32; i++) begin
            count = count + byte_counts[i];
        end
        if (count > 255) begin
            count = 8'b255;  // Clip to 255 if count exceeds
        end
        out = count;
    end

endmodule