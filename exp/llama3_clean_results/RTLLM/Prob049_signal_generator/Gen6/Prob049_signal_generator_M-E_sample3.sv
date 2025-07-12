module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;  // 5-bit counter
reg incr;  // Increment/decrement control signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 5'b00000;  // Reset counter to 0
        incr <= 1'b1;  // Initialize increment mode
    end else begin
        if (incr) begin  // Increment mode
            if (counter == 5'b11111) begin  // If counter reaches maximum
                counter <= 5'b11111;  // Hold at maximum for one cycle
                incr <= 1'b0;  // Switch to decrement mode
            end else begin
                counter <= counter + 1'b1;  // Increment counter
            end
        end else begin  // Decrement mode
            if (counter == 5'b00000) begin  // If counter reaches minimum
                counter <= 5'b00000;  // Hold at minimum for one cycle
                incr <= 1'b1;  // Switch to increment mode
            end else begin
                counter <= counter - 1'b1;  // Decrement counter
            end
        end
    end
end

assign wave = counter;  // Assign counter value to output wave

endmodule