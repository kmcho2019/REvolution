module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // 3-bit counter to keep track of the current state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0; // Reset the counter to 0
    end else begin
        // Increment the counter with each clock cycle
        counter <= counter + 1;
        
        // Wrap around to 0 when the counter reaches its maximum value
        if (counter == 7) begin
            counter <= 0;
        end
    end
end

// Use the counter value to select which bit of the output should be set high
always @(*) begin
    case (counter)
        3'd0: out = 8'b0000_0001; // Counter value 0 sets the LSB high
        3'd1: out = 8'b0000_0010;
        3'd2: out = 8'b0000_0100;
        3'd3: out = 8'b0000_1000;
        3'd4: out = 8'b0001_0000;
        3'd5: out = 8'b0010_0000;
        3'd6: out = 8'b0100_0000;
        3'd7: out = 8'b1000_0000; // Counter value 7 sets the MSB high
    endcase
end

endmodule