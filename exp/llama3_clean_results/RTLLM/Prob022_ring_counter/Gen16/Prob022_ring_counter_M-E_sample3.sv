module ring_counter(
    input  wire clk,
    input  wire reset,
    output reg  [7:0] out
);

reg [2:0] counter; // 3-bit counter

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 3'b000; // Reset counter to 0
    end else begin
        // Increment counter, it will wrap around automatically
        counter <= counter + 1'b1;
    end
end

always @(*) begin
    case (counter)
        3'b000: out = 8'b0000_0001; // State 0
        3'b001: out = 8'b0000_0010; // State 1
        3'b010: out = 8'b0000_0100; // State 2
        3'b011: out = 8'b0000_1000; // State 3
        3'b100: out = 8'b0001_0000; // State 4
        3'b101: out = 8'b0010_0000; // State 5
        3'b110: out = 8'b0100_0000; // State 6
        3'b111: out = 8'b1000_0000; // State 7
        default: out = 8'b0000_0001; // Should not occur, but default to state 0
    endcase
end

endmodule