module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // 3-bit counter to track position

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize counter to starting state (0)
        counter <= 3'b000;
    end else begin
        // Increment counter, wrapping around to 0 after 7
        counter <= (counter == 3'b111) ? 3'b000 : counter + 1'b1;
    end
end

// Use counter value to set the corresponding bit in out to 1
always @(*) begin
    case (counter)
        3'b000: out = 8'b0000_0001;
        3'b001: out = 8'b0000_0010;
        3'b010: out = 8'b0000_0100;
        3'b011: out = 8'b0000_1000;
        3'b100: out = 8'b0001_0000;
        3'b101: out = 8'b0010_0000;
        3'b110: out = 8'b0100_0000;
        3'b111: out = 8'b1000_0000;
        default: out = 8'b0000_0001; // Should not occur, but for completeness
    endcase
end

endmodule