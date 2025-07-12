module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] high_count;  // Counter for high period
reg [7:0] low_count;  // Counter for low period
reg [7:0] high_value;  // Value for high counter based on freq
reg [7:0] low_value;  // Value for low counter based on freq
reg state;  // State machine state (0 for low, 1 for high)

always @(posedge clk) begin
    if (freq != 0) begin  // Check if frequency is not zero
        high_value <= freq - 1;  // Set high counter value
        low_value <= freq - 1;  // Set low counter value for 50% duty cycle
    end

    case (state)
        1'b0: begin  // Low state
            if (low_count == 0) begin
                state <= 1'b1;  // Switch to high state
                wave_out <= 1'b1;  // Set output high
                low_count <= low_value;  // Reset low counter
                high_count <= high_value;  // Set high counter
            end else begin
                low_count <= low_count - 1;  // Decrement low counter
            end
        end
        1'b1: begin  // High state
            if (high_count == 0) begin
                state <= 1'b0;  // Switch to low state
                wave_out <= 1'b0;  // Set output low
                high_count <= high_value;  // Reset high counter
                low_count <= low_value;  // Set low counter
            end else begin
                high_count <= high_count - 1;  // Decrement high counter
            end
        end
    endcase
end

initial begin
    wave_out = 1'b0;  // Initialize output low
    state = 1'b0;  // Initialize state to low
    high_count = 0;  // Initialize high counter
    low_count = 0;  // Initialize low counter
    high_value = 0;  // Initialize high value
    low_value = 0;  // Initialize low value
end

endmodule