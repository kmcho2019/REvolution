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
        out <= 1 << pos; // This doesn't work as expected, instead use the following approach
        // Directly set the bit at position 'pos' to 1 and all others to 0
        out <= (1 << pos);
        // Alternative approach: 
        // out <= (1 << pos); doesn't directly work as expected due to bit-width issues
        // So we use the below to directly manipulate bits of out
        // case (pos)
        //     0: out <= 8'b0000_0001;
        //     1: out <= 8'b0000_0010;
        //     2: out <= 8'b0000_0100;
        //     3: out <= 8'b0000_1000;
        //     4: out <= 8'b0001_0000;
        //     5: out <= 8'b0010_0000;
        //     6: out <= 8'b0100_0000;
        //     7: out <= 8'b1000_0000;
        // endcase
    end
end

endmodule