module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Feedback taps for maximal-length 16-bit LFSR (X^16 + X^14 + X^13 + X^11 + 1)
wire feedback_bit = up_down ? 
                   (count[15] ^ count[13] ^ count[12] ^ count[10]) :  // Up count
                   ~(count[15] ^ count[13] ^ count[12] ^ count[10]);  // Down count (inverted)

always @(posedge clk) begin
    if (reset) begin
        // Initialize to non-zero value for LFSR operation
        count <= 16'h0001;
    end else begin
        if (up_down) begin
            // Up count: standard LFSR operation
            count <= {count[14:0], feedback_bit};
        end else begin
            // Down count: reverse LFSR operation
            count <= {feedback_bit, count[15:1]};
        end
    end
end

endmodule