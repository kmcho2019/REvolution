module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

// Define the Johnson counter
reg [9:0] johnson_counter;

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 0
        johnson_counter <= 10'd1;
    end else begin
        // Shift the counter to the right and wrap around to the left
        johnson_counter <= {johnson_counter[0], johnson_counter[9:1]};
    end
end

// Decode the Johnson counter output to drive a 4-bit counter
always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 0
        q <= 4'd0;
    end else if (johnson_counter[9:6] == 4'b1000) begin
        // If the most significant bits are 1000, reset the counter
        q <= 4'd0;
    end else begin
        // Otherwise, increment the counter
        q <= q + 1'b1;
    end
end

endmodule