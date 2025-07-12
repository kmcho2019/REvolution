module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // 3-bit counter to index the 8 output bits

// Always block to handle sequential logic (counter update and output generation)
always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 3'b000; // Reset counter to 0
        out <= 8'b0000_0001; // Initialize output to the starting state
    end else begin
        // Increment counter, wrapping around to 0 after reaching 7
        if (counter == 3'b111) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1'b1;
        end
        
        // Generate output based on counter value
        out <= 8'b0000_0001 << counter; // Shift 1 to the left by counter value
    end
end

endmodule