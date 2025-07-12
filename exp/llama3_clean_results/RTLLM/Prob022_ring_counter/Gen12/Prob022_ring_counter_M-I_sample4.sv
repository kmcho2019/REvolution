module ring_counter(
    input  wire clk,
    input  wire reset,
    output reg  [7:0] out
);

// 3-bit position register to keep track of the current bit in the output
reg [2:0] pos;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset position to 0 and output to initial state (LSB set to 1)
        pos <= 3'd0;
        out <= 8'b0000_0001;
    end else begin
        // Increment position and wrap around to 0 after 7
        pos <= (pos + 1) % 8;
        
        // Update output by setting the bit at the current position
        case (pos)
            3'd0: out <= 8'b0000_0001;
            3'd1: out <= 8'b0000_0010;
            3'd2: out <= 8'b0000_0100;
            3'd3: out <= 8'b0000_1000;
            3'd4: out <= 8'b0001_0000;
            3'd5: out <= 8'b0010_0000;
            3'd6: out <= 8'b0100_0000;
            3'd7: out <= 8'b1000_0000;
        endcase
    end
end

endmodule