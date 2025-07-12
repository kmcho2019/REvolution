module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] lfsr; // Linear Feedback Shift Register
reg [4:0] counter; // Counter for waveform generation

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        lfsr <= 5'b1; // Initialize LFSR with a non-zero seed value
        counter <= 0;
    end else begin
        // Update LFSR
        lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[2]}; // XOR feedback for LFSR

        // Update counter based on LFSR output
        if (lfsr[0] == 1'b1) begin
            // Increment counter
            counter <= (counter == 31) ? 0 : counter + 1;
        end else begin
            // Decrement counter
            counter <= (counter == 0) ? 31 : counter - 1;
        end
    end
end

assign wave = counter;

endmodule