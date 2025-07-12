module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [1:0] count_ones; // Counter for consecutive '1's
reg [3:0] count_matches; // Counter for total matches in sequence
reg [3:0] expected_sequence; // Expected sequence (1101)

always @(posedge clk) begin
    if (reset) begin
        count_ones <= 0; // Reset counter for consecutive '1's
        count_matches <= 0; // Reset counter for total matches
        start_shifting <= 0; // Reset start_shifting
    end else begin
        // Check if current bit matches expected bit in sequence
        if (data == expected_sequence[count_matches]) begin
            // If match, increment match counter
            count_matches <= count_matches + 1;
            // If '1', increment consecutive '1's counter
            if (data == 1) begin
                count_ones <= count_ones + 1;
            end else begin
                count_ones <= 0; // Reset consecutive '1's counter if '0'
            end
        end else begin
            // If no match, reset match counter and consecutive '1's counter
            count_matches <= 0;
            count_ones <= 0;
        end
        
        // Set start_shifting if sequence detected
        if (count_matches == 4) begin
            start_shifting <= 1;
        end
    end
end

// Initialize expected sequence (1101)
initial begin
    expected_sequence[0] = 1; // LSB
    expected_sequence[1] = 1;
    expected_sequence[2] = 0;
    expected_sequence[3] = 1; // MSB
end

endmodule