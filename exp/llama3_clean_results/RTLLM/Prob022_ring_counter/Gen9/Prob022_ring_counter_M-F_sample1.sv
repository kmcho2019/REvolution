module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // 3-bit counter for 8 states

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 3'b000; // Initialize counter to 0 when reset is high
        out <= 8'b0000_0001; // Initialize output to the starting state
    end else begin
        counter <= counter + 1; // Increment counter on each clock pulse
        if (counter == 3'b111) begin // Wrap around condition
            counter <= 3'b000;
        end
        out <= 1 << counter; // Directly set the output bit based on the counter
    end
end

endmodule