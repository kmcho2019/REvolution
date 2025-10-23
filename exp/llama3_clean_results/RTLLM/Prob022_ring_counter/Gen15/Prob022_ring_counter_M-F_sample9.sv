module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] pos; // 3 bits to represent 8 positions

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Initialize out to starting state when reset is high
        pos <= 0; // Initialize position to 0
    end else begin
        pos <= (pos + 1) % 8; // Increment position and wrap around to 0 after 7
        case (pos)
            3'd0: out <= 8'b0000_0001; // Set bit 0 to '1'
            3'd1: out <= 8'b0000_0010; // Set bit 1 to '1'
            3'd2: out <= 8'b0000_0100; // Set bit 2 to '1'
            3'd3: out <= 8'b0000_1000; // Set bit 3 to '1'
            3'd4: out <= 8'b0001_0000; // Set bit 4 to '1'
            3'd5: out <= 8'b0010_0000; // Set bit 5 to '1'
            3'd6: out <= 8'b0100_0000; // Set bit 6 to '1'
            3'd7: out <= 8'b1000_0000; // Set bit 7 to '1'
        endcase
    end
end

endmodule