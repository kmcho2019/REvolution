module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    // Initialize a variable to store the count
    reg [7:0] count;

    // Initialize a variable to store the intermediate counts
    reg [7:0] temp_count [0:7];

    // Initialize a variable to store the final count
    reg [7:0] final_count;

    // Count the number of '1's in each byte
    integer i, j;
    always @(*) begin
        count = 8'd0;
        for (i = 0; i < 32; i = i + 1) begin
            temp_count[i] = 8'd0;
            for (j = 0; j < 8; j = j + 1) begin
                if (in[i*8 + j]) begin
                    temp_count[i] = temp_count[i] + 1;
                end
            end
        end

        // Sum up the counts from each byte
        final_count = 8'd0;
        for (i = 0; i < 32; i = i + 1) begin
            final_count = final_count + temp_count[i];
        end

        out = final_count;
    end

endmodule