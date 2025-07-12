module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Initialize counters
    reg [7:0] count;

    // Count the number of '1's in each byte
    reg [7:0] byte_count [31:0];
    integer i;
    always @(in) begin
        count = 8'b0;
        for (i = 0; i < 32; i = i + 1) begin
            byte_count[i] = 8'b0;
            for (integer j = 0; j < 8; j = j + 1) begin
                if (in[(i*8)+j]) begin
                    byte_count[i] = byte_count[i] + 1'b1;
                end
            end
        end

        // Sum up the byte counts
        for (i = 0; i < 32; i = i + 1) begin
            count = count + byte_count[i];
        end

        // Assign the final count to the output
        out = count[7:0];
    end

endmodule