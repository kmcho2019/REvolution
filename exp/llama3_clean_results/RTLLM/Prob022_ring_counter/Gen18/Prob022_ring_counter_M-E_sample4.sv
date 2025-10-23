module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // 3-bit counter to keep track of the current state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize the counter to 0 on reset
        counter <= 3'b000;
    end else begin
        // Increment the counter on each rising edge of the clock signal
        counter <= counter + 1;
    end
end

// Combinational logic to generate the output vector based on the counter value
always @(*) begin
    case (counter)
        3'b000: out = 8'b0000_0001; // Least significant bit set to 1
        3'b001: out = 8'b0000_0010;
        3'b010: out = 8'b0000_0100;
        3'b011: out = 8'b0000_1000;
        3'b100: out = 8'b0001_0000;
        3'b101: out = 8'b0010_0000;
        3'b110: out = 8'b0100_0000;
        3'b111: out = 8'b1000_0000; // Most significant bit set to 1
        default: out = 8'b0000_0000; // Default case (should not occur)
    endcase
end

endmodule