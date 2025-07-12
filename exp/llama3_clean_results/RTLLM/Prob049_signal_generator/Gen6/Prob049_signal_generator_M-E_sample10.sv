module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg dir;  // 1 for increment, 0 for decrement

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 5'b00000;  // Reset counter to 0
        dir <= 1'b1;  // Initialize direction to increment
    end else begin
        if (dir == 1'b1) begin  // Incrementing
            if (counter == 5'b11111) begin  // If counter is at maximum
                dir <= 1'b0;  // Switch to decrementing
            end
            counter <= counter + 1'b1;  // Increment counter
        end else begin  // Decrementing
            if (counter == 5'b00000) begin  // If counter is at minimum
                dir <= 1'b1;  // Switch to incrementing
            end
            counter <= counter - 1'b1;  // Decrement counter
        end
    end
end

assign wave = counter;  // Assign counter value to wave

endmodule