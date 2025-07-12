module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 5'b00000;  // Reset counter to 0
    end else begin
        if (counter == 5'b11111) begin  // If counter is at maximum
            counter <= 5'b00000;  // Reset counter to 0
        end else if (counter == 5'b00000) begin  // If counter is at minimum
            counter <= counter + 1'b1;  // Start incrementing
        end else if (counter < 5'b10000) begin  // If counter is in first half
            counter <= counter + 1'b1;  // Continue incrementing
        end else begin  // If counter is in second half
            counter <= counter - 1'b1;  // Start decrementing
        end
    end
end

assign wave = counter;

endmodule