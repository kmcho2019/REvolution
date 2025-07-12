module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    reg [1:0] match_counter;  // Tracks partial matches (0-3)
    wire [3:0] expected_bits = 4'b1011; // Expected sequence in reverse (1101)

    always @(posedge clk) begin
        if (reset) begin
            match_counter <= 2'b0;
            start_shifting <= 1'b0;
        end else if (!start_shifting) begin
            if (data == expected_bits[match_counter]) begin
                // Correct bit in sequence - advance counter
                match_counter <= match_counter + 1;
                if (match_counter == 2'b11) begin
                    start_shifting <= 1'b1;  // Full match
                end
            end else begin
                // Mismatch - reset counter if needed
                match_counter <= (data == expected_bits[0]) ? 2'b1 : 2'b0;
            end
        end
    end

endmodule